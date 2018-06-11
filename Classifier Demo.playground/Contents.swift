import Foundation
import PlaygroundSupport

guard #available(OSX 10.14, *) else {
    fatalError()
}

import CoreML
import NaturalLanguage

let url = Bundle.main.url(forResource: "ProgrammingLanguageClassifier", withExtension: "mlmodelc")!
let model = try! NLModel(contentsOf: url)

let view = DragAndDropView()
view.dragOperation = { string in
    view.stringValue = model.predictedLabel(for: string) ?? ""
}

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
