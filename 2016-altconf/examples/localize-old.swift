#!/usr/bin/env xcrun swift -I CommonCrypto

import Foundation
import CommonCrypto

// MARK: String

extension String {
    func truncate(length: Int) -> String {
        if characters.count > length {
            return substringToIndex(startIndex.advancedBy(length))
        } else {
            return self
        }
    }
}

// MARK: - Crypto

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
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

func sanitizedStringForLocalization(string: String) -> String {
    var result = string;
    let nonAlphaNumeric = NSCharacterSet.alphanumericCharacterSet().invertedSet.mutableCopy() as! NSMutableCharacterSet
    nonAlphaNumeric.removeCharactersInString(" ")
    result = result.componentsSeparatedByCharactersInSet(nonAlphaNumeric).joinWithSeparator("")
    result = result.stringByReplacingOccurrencesOfString(" ", withString: "_")
    return result.lowercaseString.truncate(20)
}

func hashForKey(key: String, description: String?) -> String {
    let hash: String
    if let description = description {
        hash = (key + description).sha1()
    } else {
        hash = key.sha1()
    }
    return hash.truncate(8)
}

func lookUpStringForKey(key: String, description: String? = nil) -> String {
    var lookUp = "ios-\(sanitizedStringForLocalization(key))"
    if let description = description {
        lookUp = lookUp + "-\(sanitizedStringForLocalization(description))"
    }
    lookUp = lookUp + "-\(hashForKey(key, description: description))"
    return lookUp
}

func getMatches(line: String) throws -> [NSTextCheckingResult] {
    let pattern = "WFLocalizedString\\(@\"([^\"]*)\"\\)"
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matchesInString(line, options: [], range: NSRange(location: 0, length: line.utf16.count))
    
    if matches.count > 0 {
        return matches
    }
    
    let descriptivePattern = "WFLocalizedStringWithDescription\\(@\"([^\"]*)\", @\"([^\"]*)\"\\)"
    let descriptiveRegex = try NSRegularExpression(pattern: descriptivePattern, options: [])
    return descriptiveRegex.matchesInString(line, options: [], range: NSRange(location: 0, length: line.utf16.count))
}

func getLocalizedStrings(line: String) throws -> [LocalizedString] {
    let matches = try getMatches(line)
    return matches.flatMap {
        let line = line as NSString
        let string = line.substringWithRange($0.rangeAtIndex(1))
        
        var description: String? = nil
        if $0.numberOfRanges > 2 {
            description = line.substringWithRange($0.rangeAtIndex(2))
        }
        
        return LocalizedString(string: string, description: description)
    }
}

func localizationKeyValueLineFromLocalizedString(localizedString: LocalizedString) -> String {
    return "\"\(lookUpStringForKey(localizedString.string, description: localizedString.description))\" = \"\(localizedString.string)\";"
}

func descriptionCommentLineFromLocalizedString(localizedString: LocalizedString) -> String? {
    guard let description = localizedString.description else { return nil }
    return "/* \(description) */"
}

func localizationLinesFromLocalizedString(localizedString: LocalizedString) -> String {
    var lines = ""
    if let descriptionCommentLine = descriptionCommentLineFromLocalizedString(localizedString) {
        lines = lines + descriptionCommentLine + "\n"
    }
    return lines + localizationKeyValueLineFromLocalizedString(localizedString)
}

// MARK: - File System

func getEnumeratorForDirectory(directory: String) -> NSDirectoryEnumerator? {
    guard
        let directoryURL = NSURL(string: directory),
        let enumerator = NSFileManager.defaultManager().enumeratorAtURL(directoryURL, includingPropertiesForKeys: nil, options: [.SkipsPackageDescendants, .SkipsHiddenFiles], errorHandler: nil)
        else {
            print("Error: \(directory) directory not found.")
            return nil
    }
    return enumerator
}

func localize(directory: String) throws {
    let outputFile = directory + "/Localization/Base.lproj/Localizable.strings"
    print("Writing to file: \(outputFile)")

    guard let enumerator = getEnumeratorForDirectory(directory) else { return }
    guard let URLs = enumerator.allObjects as? [NSURL] else {
        print("Unexpected error: Enumerator contained item that is not NSURL.")
        return
    }
    
    let implementationURLs = URLs.filter { URL in
        return URL.lastPathComponent!.hasSuffix(".m") || URL.lastPathComponent!.hasSuffix(".mm")
    }
    
    var uniqueLocalizedStrings = Set<LocalizedString>()
    for URL in implementationURLs {
        guard let code = try? String(contentsOfURL: URL, encoding: NSUTF8StringEncoding) else {
            continue;
        }
        let localizedStrings = try getLocalizedStrings(code)
        for l in localizedStrings {
            uniqueLocalizedStrings.insert(l)
        }
    }
    
    var output = ""
    
    let uniqueLocalizedStringsArray = Array(uniqueLocalizedStrings)
    let sortedUniqueLocalizedString = uniqueLocalizedStringsArray.sort { first, second in
        if first != second { return first.string < second.string }
        return first.description < second.description
    }
    for string in sortedUniqueLocalizedString {
        output = output + localizationLinesFromLocalizedString(string) + "\n\n"
    }
    
    try output.writeToFile(outputFile, atomically: false, encoding: NSUTF8StringEncoding)
}

// MARK: - Script

func run(workspaceDirectory: String) throws {
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
