#!/usr/bin/swift

import Foundation

guard #available(OSX 10.14, *) else {
    fatalError()
}

import CreateML
import NaturalLanguage

enum ProgrammingLanguage: String {
    case c = "C"
    case cPlusPlus = "C++"
    case go = "Go"
    case java = "Java"
    case javaScript = "JavaScript"
    case objectiveC = "Objective-C"
    case php = "PHP"
    case ruby = "Ruby"
    case rust = "Rust"
    case swift = "Swift"

    init?(for fileURL: URL, at level: Int) {
        let pathComponents = fileURL.pathComponents
        let directory = pathComponents[pathComponents.count - level]
        switch (directory, fileURL.pathExtension) {
        case ("c", "h"), (_, "c"): self = .c
        case ("cc", "h"), (_, "cc"), (_, "cpp"): self = .cPlusPlus
        case (_, "go"): self = .go
        case (_, "java"): self = .java
        case (_, "js"): self = .javaScript
        case ("objective-c", "h"), (_, "m"): self = .objectiveC
        case (_, "php"): self = .php
        case (_, "rb"): self = .ruby
        case (_, "rs"): self = .rust
        case (_, "swift"): self = .swift
        default:
            return nil
        }
    }
}

let destinationPath = <#path/to/ProgrammingLanguageClassifier.mlmodel#>

let corpusPath = <#path/to/code-corpora#>
let corpusURL = URL(fileURLWithPath: corpusPath)

do {
    var corpus: [(text: String, label: String)] = []

    let enumerator = FileManager.default.enumerator(at: corpusURL, includingPropertiesForKeys: [.isDirectoryKey])!
    for case let resource as URL in enumerator {
        guard !resource.hasDirectoryPath,
            let language = ProgrammingLanguage(for: resource, at: enumerator.level),
            let text = try? String(contentsOf: resource)
        else {
            continue
        }
        corpus.append((text: text, label: language.rawValue))
    }

    let (texts, labels): ([String], [String]) = corpus.reduce(into: ([], [])) {
        $0.0.append($1.text)
        $0.1.append($1.label)
    }
    let dataTable = try MLDataTable(dictionary: ["text": texts, "label": labels])

    // As of Xcode 10.0 beta (10L176w),
    // attempted use of CRF algorithm results in EXC_BAD_ACCESS.
    // See https://gist.github.com/mattt/1ce5101abfdb87d1bba60a680ec6b29b
    /*
    var trainingData: MLDataTable
    var testingData: MLDataTable
    var validationData: MLDataTable

    (trainingData, testingData) = dataTable.randomSplit(by: 0.8, seed: 0)
    (trainingData, validationData) = trainingData.randomSplit(by: 0.95, seed: 0)
    let parameters = MLTextClassifier.ModelParameters(validationData: validationData, algorithm: .crf(revision: 1), language: .english)
    let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label", parameters: parameters)
    */

    let (trainingData, testingData) = dataTable.randomSplit(by: 0.8, seed: 0)
    let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label")

    let evaluation = classifier.evaluation(on: testingData)
    print(evaluation)

    let modelPath = URL(fileURLWithPath: destinationPath)
    let metadata = MLModelMetadata(author: "Mattt", shortDescription: "A model trained to classify programming languages", version: "1.0")
    try classifier.write(to: modelPath, metadata: metadata)
} catch {
    print(error)
}
