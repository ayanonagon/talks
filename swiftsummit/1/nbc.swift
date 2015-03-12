#!/usr/bin/env xcrun swift -F /Carthaage/Build

import Foundation

// MARK: - NSLinguisticTagger

typealias TaggedToken = (String, String?) // Can’t add tuples to an array without typealias. Compiler bug... Sigh.

func tag(text: String, scheme: String) -> [TaggedToken] {
    let options: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation | .OmitOther
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
        options: Int(options.rawValue))
    tagger.string = text

    var tokens: [TaggedToken] = []

    // Using NSLinguisticTagger
    tagger.enumerateTagsInRange(NSMakeRange(0, countElements(text)), scheme:scheme, options: options) { tag, tokenRange, _, _ in
        let token = (text as NSString).substringWithRange(tokenRange)
        tokens.append((token, tag))
    }
    return tokens
}

func lemmatize(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLemma)
}

func unique<T:Hashable>(list: [T]) -> [T] {  
    var filter = Dictionary<T,Bool>()
    for (i, _) in enumerate(list) {
        filter[list[i]] = true
    }
    return Array(filter.keys)
}

// MARK: - NaiveBayesClassifier

public class NaiveBayesClassifier {
    public typealias Category = String

    private let tokenizer: String -> [String]

    private var categoryOccurrences: [Category: Int] = [:]
    private var tokenOccurrences: [String: [Category: Int]] = [:]
    private var trainingCount = 0
    private var tokenCount = 0

    private let smoothingParameter = 1.0

    public init(tokenizer: (String -> [String])) {
        self.tokenizer = tokenizer
    }

    // MARK: - Training

    public func trainWithText(text: String, category: Category) {
        trainWithTokens(tokenizer(text), category: category)
    }

    public func trainWithTokens(tokens: [String], category: Category) {
        let tokens = unique(tokens)
        for token in tokens {
            incrementToken(token, category: category)
        }
        incrementCategory(category)
        trainingCount++
    }

    // MARK: - Classifying

    public func classifyText(text: String) -> Category? {
        return classifyTokens(tokenizer(text))
    }

    public func classifyTokens(tokens: [String]) -> Category? {
        // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
        var maxCategory: Category?
        var maxCategoryScore = -Double.infinity
        for (category, _) in categoryOccurrences {
            let pCategory = P(category)
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                // P(W=token|C=cat) = P(C=cat, W=token) / P(C=cat)
                total + log((self.P(category, token) + self.smoothingParameter) / (pCategory + self.smoothingParameter * Double(self.tokenCount)))
            }
            if score > maxCategoryScore {
                maxCategory = category
                maxCategoryScore = score
            }
        }
        return maxCategory
    }

    // MARK: - Probabilites

    private func P(category: Category, _ token: String) -> Double {
        return Double(tokenOccurrences[token]?[category] ?? 0) / Double(trainingCount)
    }

    private func P(category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category)) / Double(trainingCount)
    }

    // MARK: - Counting

    private func incrementToken(token: String, category: Category) {
        if tokenOccurrences[token] == nil {
            tokenCount++
            tokenOccurrences[token] = [:]
        }

        // Force unwrap to crash instead of providing faulty results.
        let count = tokenOccurrences[token]![category] ?? 0
        tokenOccurrences[token]![category] = count + 1
    }

    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category) + 1
    }

    private func totalOccurrencesOfToken(token: String) -> Int {
        if let occurrences = tokenOccurrences[token] {
            return reduce(occurrences.values, 0, +)
        }
        return 0
    }

    private func totalOccurrencesOfCategory(category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }
}

// MARK: - Script

let nbc = NaiveBayesClassifier { (text: String) -> [String] in
    return lemmatize(text).map { (token, tag) in 
        return tag ?? token
    }
}

let fileManager = NSFileManager.defaultManager()

// MARK: - Train with Spam

println("Eating spam...")

let spamTrainingEnumerator = fileManager.enumeratorAtPath("train/spam")

var totalSpamTraining = 0

while let fileName = spamTrainingEnumerator!.nextObject() as? String {
    if let spam = String(contentsOfFile: "train/spam/\(fileName)",
                               encoding: NSUTF8StringEncoding, error: nil) {
        nbc.trainWithText(spam, category: "spam")
        totalSpamTraining += 1
    }
}

println("Trained with \(totalSpamTraining) spam examples")

// MARK: - Train with Ham

println("Eating ham...")

let hamTrainingEnumerator = fileManager.enumeratorAtPath("train/ham")

var totalHamTraining = 0

while let fileName = hamTrainingEnumerator!.nextObject() as? String {
    if let ham = String(contentsOfFile: "train/ham/\(fileName)",
                              encoding: NSUTF8StringEncoding, error: nil) {
        nbc.trainWithText(ham, category: "ham")
        totalHamTraining += 1
    }
}

println("Trained with \(totalHamTraining) ham examples")

// MARK: - Classify Ham

println("Classifying ham...")

let hamClassifyingEnumerator = fileManager.enumeratorAtPath("test/ham")

var totalHamTesting = 0
var totalHamCorrect = 0

while let fileName = hamClassifyingEnumerator!.nextObject() as? String {
    if let ham = String(contentsOfFile: "test/ham/\(fileName)",
                              encoding: NSUTF8StringEncoding, error: nil) {
        if nbc.classifyText(ham) == "ham" {
           totalHamCorrect += 1 
        }
        totalHamTesting += 1
    }
}

println("Correctly marked \(totalHamCorrect) out of \(totalHamTesting) as ham")

// MARK: - Classify Spam

println("Classifying spam...")

let spamClassifyingEnumerator = fileManager.enumeratorAtPath("test/spam")

var totalSpamTesting = 0
var totalSpamCorrect = 0

while let fileName = spamClassifyingEnumerator!.nextObject() as? String {
    if let spam = String(contentsOfFile: "test/spam/\(fileName)",
                               encoding: NSUTF8StringEncoding, error: nil) {
        if nbc.classifyText(spam) == "spam" {
           totalSpamCorrect += 1 
        }
        totalSpamTesting += 1
    }
}

println("Correctly marked \(totalSpamCorrect) out of \(totalSpamTesting) as spam")

