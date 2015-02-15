// Linguistics.swift

import Foundation

typealias Tokens = [String]

func tag(text: String, scheme: String) -> Tokens {
    let options: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation | .OmitOther
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
        options: Int(options.rawValue))
    tagger.string = text

    var tokens: Tokens = []

    tagger.enumerateTagsInRange(NSMakeRange(0, countElements(text)), scheme:scheme, options: options) { tag, tokenRange, _, _ in
        if (tag != nil) {
            tokens.append(tag)
        } else {
            tokens.append((text as NSString).substringWithRange(tokenRange))
        }
    }
    return tokens
}

func partOfSpeech(text: String) -> Tokens {
    return tag(text, NSLinguisticTagSchemeLexicalClass)
}

partOfSpeech("The quick brown fox")

func lemmatize(text: String) -> Tokens {
    return tag(text, NSLinguisticTagSchemeLemma)
}

lemmatize("")

func language(text: String) -> Tokens {
    return tag(text, NSLinguisticTagSchemeLanguage)
}

language("Hoe gaat het met jou?")
language("Ich bin Ayaka")
language("こんにちは")

func name(text: String) -> Tokens {
    return tag(text, NSLinguisticTagSchemeNameTypeOrLexicalClass)
}

name("I am on a plane to New York right now")
name("I am in San Francisco")

typealias Category = String
typealias Token = String

class NaiveBayesClassifier {
    var categoryCounts: [Category : Int]
    var categoryTokenCounts: [Category : [Token : Int]]

    init() {
        categoryCounts = [Category : Int]()
        categoryTokenCounts = [Category : [Token : Int]]()
    }

    func trainWithExample(text: String, category: Category) {

    }

    func classify(text: String) -> Category {
        return "ham"
    }
}
