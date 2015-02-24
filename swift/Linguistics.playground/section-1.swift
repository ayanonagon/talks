// Linguistics.playground

import Foundation

typealias Token = String
typealias TaggedToken = (Token, String) // Can’t add tuples to an array without typealias. Compiler bug...

func tag(text: String, scheme: String) -> [TaggedToken] {
    let options: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation | .OmitOther
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
        options: Int(options.rawValue))
    tagger.string = text

    var tokens: [TaggedToken] = []

    tagger.enumerateTagsInRange(NSMakeRange(0, count(text)), scheme:scheme, options: options) { tag, tokenRange, _, _ in
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

func tokenize(text: String) -> [Token] {
    return partOfSpeech(text).map { (token, tag) in
        return token
    }
}

typealias Category = String

private let smoothingParameter = 1.0

public class NaiveBayesClassifier {
    public typealias Word = String
    public typealias Category = String

    private var categoryOccurrences: [Category: Int] = [:]
    private var wordOccurrences: [Word: [Category: Int]] = [:]
    private var trainingCount = 0
    private var wordCount = 0

    // MARK: - Training

    public func trainWithText(text: String, category: Category) {
        self.trainWithTokens(tokenize(text), category: category)
    }

    public func trainWithTokens(tokens: [Word], category: Category) {
        let words = Set(tokens)
        for word in words {
            incrementWord(word, category: category)
        }
        incrementCategory(category)
        trainingCount++
    }

    // MARK: - Classifying

    public func classifyText(text: String) -> Category? {
        return self.classifyTokens(tokenize(text))
    }

    public func classifyTokens(tokens: [Word]) -> Category? {
        // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
        var maxCategory: Category?
        var maxCategoryScore = -Double.infinity
        for (category, _) in categoryOccurrences {
            let pCategory = self.P(category)
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                total + log((self.P(category, token) + smoothingParameter) / (pCategory + smoothingParameter + Double(self.wordCount)))
            }
            if score > maxCategoryScore {
                maxCategory = category
                maxCategoryScore = score
            }
        }
        return maxCategory
    }

    // MARK: - Probabilites

    private func P(category: Category, _ word: Word) -> Double {
        if let occurrences = wordOccurrences[word] {
            let count = occurrences[category] ?? 0
            return Double(count) / Double(trainingCount)
        }
        return 0.0
    }

    private func P(category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category)) / Double(trainingCount)
    }

    // MARK: - Counting

    private func incrementWord(word: Word, category: Category) {
        if wordOccurrences[word] == nil {
            wordCount++
            wordOccurrences[word] = [:]
        }

        let count = wordOccurrences[word]?[category] ?? 0
        wordOccurrences[word]?[category] = count + 1
    }

    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category) + 1
    }

    private func totalOccurrencesOfWord(word: Word) -> Int {
        if let occurrences = wordOccurrences[word] {
            return Array(occurrences.values).reduce(0, combine: +)
        }
        return 0
    }

    private func totalOccurrencesOfCategory(category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }
}

let nbc = NaiveBayesClassifier()

nbc.trainWithText("spammy spam spam", category: "spam")
nbc.trainWithText("what does the fox say?", category: "spam")
nbc.trainWithText("and fish go blub", category: "spam")

nbc.trainWithText("nom nom ham", category: "ham")
nbc.trainWithText("make sure to get the ham", category: "ham")
nbc.trainWithText("please put the eggs in the fridge", category: "ham")

nbc.classifyText("what does the fish say?")
nbc.classifyText("use the eggs in the fridge")
