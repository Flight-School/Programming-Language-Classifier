public enum ProgrammingLanguage: String {
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

    public init?(directory: String, fileExtension: String?) {
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

extension ProgrammingLanguage: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
