// Linguistics.swift

import Foundation

typealias Token = String
typealias TaggedToken = (Token, String) // Can’t add tuples to an array without typealias. Compiler bug...

func tag(text: String, scheme: String) -> [TaggedToken] {
    let options: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation | .OmitOther
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
        options: Int(options.rawValue))
    tagger.string = text

    var tokens: [TaggedToken] = []

    tagger.enumerateTagsInRange(NSMakeRange(0, countElements(text)), scheme:scheme, options: options) { tag, tokenRange, _, _ in
        let token = (text as NSString).substringWithRange(tokenRange)
        tokens.append((token, tag))
    }
    return tokens
}

func partOfSpeech(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLexicalClass)
}

partOfSpeech("The quick brown fox")

func lemmatize(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLemma)
}

lemmatize("I went to the store")

func language(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLanguage)
}

language("Hoe gaat het met jou?")
language("Ich bin Ayaka")
language("こんにちは")

func name(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeNameTypeOrLexicalClass)
}

name("I am on a plane to New York right now")
name("I am in San Francisco")

typealias Category = String

class NaiveBayesClassifier {
    var categoryCounts: [Category : Int]
    var categoryTokenCounts: [Category : [Token : Int]]
    var trainingCount: Int

    init() {
        categoryCounts = [Category : Int]()
        categoryTokenCounts = [Category : [Token : Int]]()
        trainingCount = 0
    }

    func trainWithExample(text: String, category: Category) {
        incrementCategory(category)
        let tokens = lemmatize(text) // TODO: Tokenize, not lemmatize
        // TODO: Remove duplicates in tokens
        for (token, _) in tokens {
            incrementCategoryTokenCount(category, token: token)
        }
        trainingCount += 1
    }

    func incrementCategory(category: Category) {
        if (categoryCounts[category] == nil) {
            categoryCounts[category] = 0
        }
        categoryCounts[category] = categoryCounts[category]! + 1
    }

    func incrementCategoryTokenCount(category: Category, token: Token) {
        if (categoryTokenCounts[category] == nil) {
            categoryTokenCounts[category] = [Token : Int]()
        }
        if (categoryTokenCounts[category]![token] == nil) {
            categoryTokenCounts[category]![token] = 0
        }
        categoryTokenCounts[category]![token]! = categoryTokenCounts[category]![token]! + 1
    }

    func classify(text: String) -> Category {
        // TODO: Implement
        return ""
    }
}

