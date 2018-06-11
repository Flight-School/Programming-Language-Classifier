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

    init?(directory: String, fileExtension: String?) {
        switch (directory, fileExtension) {
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

let destinationPath = "/Users/mattt/Desktop/Classifier.mlmodel"

let corpusPath = "/Users/mattt/Downloads/code-corpora"
let corpusURL = URL(fileURLWithPath: corpusPath)

let fileManager = FileManager.default

do {
    var corpus: [(text: String, label: String)] = []

    for directory in try fileManager.contentsOfDirectory(at: corpusURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]) {
        guard directory.hasDirectoryPath,
            let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: [.isDirectoryKey])
        else {
            continue
        }

        for case let resource as URL in enumerator {
            guard !resource.hasDirectoryPath,
                let language = ProgrammingLanguage(directory: directory.lastPathComponent, fileExtension: resource.pathExtension),
                let text = try? String(contentsOf: resource)
            else {
                 continue
            }
            corpus.append((text: text, label: language.rawValue))
        }
    }

    let (texts, labels) = corpus.reduce(into: ([String](), [String]())) {
        $0.0.append($1.text)
        $0.1.append($1.label)
    }

    let dataTable = try MLDataTable(dictionary: ["text": texts, "label": labels])

    let (trainingData, testingData) = dataTable.randomSplit(by: 0.9, seed: 0)

    // As of Xcode 10.0 beta (10L176w),
    // attempted use of CRF algorithm results in EXC_BAD_ACCESS.
    /*
    let parameters = MLTextClassifier.ModelParameters(validationData: validationData, algorithm: .crf(revision: 1), language: .english)
    let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label", parameters: parameters)
     */

    let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label")

    classifier.modelParameters.algorithm

    let evaluation = classifier.evaluation(on: testingData)
    print(evaluation)

    let modelPath = URL(fileURLWithPath: destinationPath)
    try classifier.write(to: modelPath)
} catch {
    print(error)
}
