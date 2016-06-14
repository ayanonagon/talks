//: Playground - noun: a place where people can play

import UIKit

func matches(in line: String) throws -> [TextCheckingResult] {
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

struct LocalizedString {
    let string: String
    let description: String?
}

func localizedStrings(in line: String) throws -> [LocalizedString] {
    return try matches(in: line).map {
        let line = line as NSString
        let string = line.substring(with: $0.range(at: 1))
        
        var description: String? = nil
        if $0.numberOfRanges > 2 {
            description = line.substring(with: $0.range(at: 2))
        }
        
        return LocalizedString(string: string, description: description)
    }
}

try? localizedStrings(in: "[self setTitle:WFLocalizedString(@\"Create Workflow\") forState:UIControlStateNormal];")
try? localizedStrings(in: "[self setTitle:WFLocalizedStringWithDescription(@\"Create Workflow\", @\"Button\") forState:UIControlStateNormal];")
