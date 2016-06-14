//: Playground - noun: a place where people can play

import UIKit

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

struct LocalizedString {
    let string: String
    let description: String?
}

func getLocalizedStrings(line: String) throws -> [LocalizedString] {
    let matches = try getMatches(line)
    return matches.map {
        let line = line as NSString
        let string = line.substringWithRange($0.rangeAtIndex(1))
        
        var description: String? = nil
        if $0.numberOfRanges > 2 {
            description = line.substringWithRange($0.rangeAtIndex(2))
        }
        
        return LocalizedString(string: string, description: description)
    }
}

try? getLocalizedStrings("[self setTitle:WFLocalizedString(@\"Create Workflow\") forState:UIControlStateNormal];")
try? getLocalizedStrings("[self setTitle:WFLocalizedStringWithDescription(@\"Create Workflow\", @\"Button\") forState:UIControlStateNormal];")
