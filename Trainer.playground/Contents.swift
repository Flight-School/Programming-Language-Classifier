import Foundation

guard #available(OSX 10.14, *) else {
    fatalError()
}

import CreateML
import NaturalLanguage

//let destinationPath = <#Path to Destination.mlmodel#>

//let corpusPath = "<#Path to Corpus Directory#>"
let corpusURL = URL(fileURLWithPath: corpusPath)

let fileManager = FileManager.default

try fileManager.contentsOfDirectory(at: corpusURL, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)

do {
    var corpus = try MLDataTable(dictionary: ["text": [""], "label": [""]])
    
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
            
            let dataTable = try MLDataTable(dictionary: ["text": text, "label": language.description])
            corpus.append(contentsOf: dataTable)
        }
    }
    
    let (trainingData, testingData) = corpus.randomSplit(by: 0.9, seed: 0)
    
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
