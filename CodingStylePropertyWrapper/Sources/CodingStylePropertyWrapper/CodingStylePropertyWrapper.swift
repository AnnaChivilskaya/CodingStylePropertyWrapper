import Foundation

@propertyWrapper
public struct CodingStylePropertyWrapper {

    public enum Style {
        case snake
        case kebab
        case camel
    }
    
    public init(wrappedValue: String, style: Style) {
        self.value = wrappedValue
        self.caseStyle = style
    }
    

    private var value: String
    private let caseStyle: Style
    private static let codings: [Style: (String) -> String] = [
        .snake: { value in value.lowercased()
            .split(separator: " ")
            .drop { $0.isEmpty }
            .joined(separator: "_")
        },
        .kebab: { value in
            value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .joined(separator: "-")
        },
        .camel: { value in
            let value = value.lowercased()
                .split(separator: " ")
                .drop { $0.isEmpty }
                .map { $0.prefix(1).uppercased()+$0.dropFirst() }
                .joined()
            return value.prefix(1).lowercased()+value.dropFirst()
        }
    ]

    private func get() -> String {
        guard let coding = CodingStylePropertyWrapper.codings[caseStyle] else { return value }
        return coding(value)
    }

    private mutating func set(_ newValue: String) {
        value = newValue
    }

    public var wrappedValue: String {
        get {
            get()
        }
        set {
            set(newValue)
        }
    }
}
