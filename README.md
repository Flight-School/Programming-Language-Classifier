# Programming Language Classifier

An example of how to use CreateML and Xcode 10
to train a CoreML model that is used by the Natural Language framework
to classify the programming language of source code.

```swift
let code = """
struct Plane: Codable {
    var manufacturer: String
    var model: String
    var seats: Int
}
"""

let url = Bundle.main.url(forResource: "Classifier",
                          withExtension: "mlmodelc")!
let model = try! NLModel(contentsOf: url)
model.predictedLabel(for: code) // Swift
```

## Requirements

- macOS Mojave Beta
- Xcode 10 Beta

_These are available for Apple Developer account members to download
at <https://developer.apple.com/download/>_

## Usage

This project includes a pre-trained programming language classifier model.
To see it in action, open `Classifier Demo.playground`,
run the playground with the Assistant editor showing the Live View,
and then drag and drop a source code file.
The model will predict the language of the file based on its contents.

![Screenshot of Classifier Example](https://user-images.githubusercontent.com/7659/41239573-6d49e2da-6d4d-11e8-8a89-7075659a0845.png)

## Training Instructions

- Clone and setup the repository by running the following commands:

```terminal
$ git clone https://github.com/flight-school/Programming-Language-Classifier.git`
$ cd Programming-Language-Classifier
$ git submodule update --init
```

- Open `Trainer.swift` in an editor and fill in the placeholder values
  for `destinationPath` and `corpusPath`:

```terminal
$ open ./Trainer.swift
```

- Run `Trainer.swift` and wait for the model to be trained
  _(on a 2017 MacBook Pro, this took a few minutes)_:

```terminal
$ swift ./Trainer.swift
```

- Compile the generated `.mlmodel` bundle using the following command:

```terminal
$ xcrun coremlc compile path/to/ProgrammingLanguageClassifier.mlmodel .
```

- Move the compiled `.mlmodelc` bundle into the Resources directory
  of `Classifier Demo.playground`, replacing any existing resource.

## License

MIT

See [code-corpora](https://github.com/source-foundry/code-corpora)
for licensing information of the included projects.

## About Flight School

Flight School is a new book series for Swift developers.
Each month, we'll explore an essential part of
iOS, macOS, and Swift development through concise, focused books.

If you'd like to get in touch,
feel free to message us on Twitter
([@flightdotschool](https://twitter.com/flightdotschool))
or email us at <mailto:info@flight.school>.
