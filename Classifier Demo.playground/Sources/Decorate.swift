let symbols: [String] = ["🧙‍♀️", "🧙‍♂️", "🔮", "✨", "⚡️", "💫", "🤓", "🤭", "🤔", "⁉️"]

public func decorate(_ string: String) -> String {
    guard !string.isEmpty else {
        return string
    }
    
    guard let symbol = symbols.randomElement() else {
        return string
    }
    
    return "\(symbol) \(string)"
}
