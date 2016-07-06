#!/usr/bin/env xcrun swift -I CommonCrypto

import Foundation
import CommonCrypto

// MARK: String

extension String {
    func truncate(_ length: Int) -> String {
        if characters.count > length {
            return substring(to: characters.index(startIndex, offsetBy: length))
        } else {
            return self
        }
    }
}

// MARK: - Crypto

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
}

// MARK: - Localization

struct LocalizedString: Hashable, Equatable {
    let string: String
    let description: String?
    
    var hashValue: Int {
        guard let description = description else { return string.hashValue }
        return string.hashValue ^ description.hashValue
    }
}

func ==(lhs: LocalizedString, rhs: LocalizedString) -> Bool {
    return lhs.string == rhs.string && lhs.description == rhs.description
}

func sanitizedStringForLocalization(_ string: String) -> String {
    var result = string;
    let nonAlphaNumeric = (CharacterSet.alphanumerics.inverted as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
    nonAlphaNumeric.removeCharacters(in: " ")
    result = result.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    result = result.replacingOccurrences(of: " ", with: "_")
    return result.lowercased().truncate(20)
}

func hashForKey(_ key: String, description: String?) -> String {
    let hash: String
    if let description = description {
        hash = (key + description).sha1()
    } else {
        hash = key.sha1()
    }
    return hash.truncate(8)
}

func lookUpStringForKey(_ key: String, description: String? = nil) -> String {
    var lookUp = "ios-\(sanitizedStringForLocalization(key))"
    if let description = description {
        lookUp = lookUp + "-\(sanitizedStringForLocalization(description))"
    }
    lookUp = lookUp + "-\(hashForKey(key, description: description))"
    return lookUp
}

func getMatches(_ line: String) throws -> [TextCheckingResult] {
    let pattern = "WFLocalizedString\\(@\"([^\"]*)\"\\)"
    let regex = try RegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
    
    if matches.count > 0 {
        return matches
    }
    
    let descriptivePattern = "WFLocalizedStringWithDescription\\(@\"([^\"]*)\", @\"([^\"]*)\"\\)"
    let descriptiveRegex = try RegularExpression(pattern: descriptivePattern, options: [])
    return descriptiveRegex.matches(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
}

func getLocalizedStrings(_ line: String) throws -> [LocalizedString] {
    let matches = try getMatches(line)
    return matches.flatMap {
        let line = line as NSString
        let string = line.substring(with: $0.range(at: 1))
        
        var description: String? = nil
        if $0.numberOfRanges > 2 {
            description = line.substring(with: $0.range(at: 2))
        }
        
        return LocalizedString(string: string, description: description)
    }
}

func localizationKeyValueLineFromLocalizedString(_ localizedString: LocalizedString) -> String {
    return "\"\(lookUpStringForKey(localizedString.string, description: localizedString.description))\" = \"\(localizedString.string)\";"
}

func descriptionCommentLineFromLocalizedString(_ localizedString: LocalizedString) -> String? {
    guard let description = localizedString.description else { return nil }
    return "/* \(description) */"
}

func localizationLinesFromLocalizedString(_ localizedString: LocalizedString) -> String {
    var lines = ""
    if let descriptionCommentLine = descriptionCommentLineFromLocalizedString(localizedString) {
        lines = lines + descriptionCommentLine + "\n"
    }
    return lines + localizationKeyValueLineFromLocalizedString(localizedString)
}

// MARK: - File System

func getEnumeratorForDirectory(_ directory: String) -> FileManager.DirectoryEnumerator? {
    guard
        let directoryURL = URL(string: directory),
        let enumerator = FileManager.default().enumerator(at: directoryURL, includingPropertiesForKeys: nil, options: [.skipsPackageDescendants, .skipsHiddenFiles], errorHandler: nil)
        else {
            print("Error: \(directory) directory not found.")
            return nil
    }
    return enumerator
}

func localize(_ directory: String) throws {
    let outputFile = directory + "/Localization/Base.lproj/Localizable.strings"
    print("Writing to file: \(outputFile)")

    guard let enumerator = getEnumeratorForDirectory(directory) else { return }
    guard let URLs = enumerator.allObjects as? [URL] else {
        print("Unexpected error: Enumerator contained item that is not NSURL.")
        return
    }
    
    let implementationURLs = URLs.filter { URL in
        return URL.lastPathComponent!.hasSuffix(".m") || URL.lastPathComponent!.hasSuffix(".mm")
    }
    
    var uniqueLocalizedStrings = Set<LocalizedString>()
    for URL in implementationURLs {
        guard let code = try? String(contentsOfURL: URL, encoding: String.Encoding.utf8) else {
            continue;
        }
        let localizedStrings = try getLocalizedStrings(code)
        for l in localizedStrings {
            uniqueLocalizedStrings.insert(l)
        }
    }
    
    var output = ""
    
    let uniqueLocalizedStringsArray = Array(uniqueLocalizedStrings)
    let sortedUniqueLocalizedString = uniqueLocalizedStringsArray.sorted { first, second in
        if first != second { return first.string < second.string }
        return first.description < second.description
    }
    for string in sortedUniqueLocalizedString {
        output = output + localizationLinesFromLocalizedString(string) + "\n\n"
    }
    
    try output.write(toFile: outputFile, atomically: false, encoding: String.Encoding.utf8)
}

// MARK: - Script

func run(_ workspaceDirectory: String) throws {
    let directories = ["Workflow", "WorkflowUI", "ActionKit"]
    for directory in directories {
        try localize(workspaceDirectory + "/" + directory)
    }
}

func main() {
    guard Process.arguments.count > 1 else {
        print("Please provide the project directory.")
        return
    }
    do {
        try run(Process.arguments[1])
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}

main()
