//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/27/24.
//

import SwiftUI

// extension AttributedString {
//    init(swiftCode: String) {
//        var attributedString = AttributedString(swiftCode)
//
//        // Define attributes for syntax highlighting
//        let keywords: Set<String> = ["let", "var", "func", "return", "if", "else", "for", "while", "class", "struct", "enum", "import"]
//        var keywordAttributes = AttributeContainer()
//        keywordAttributes.foregroundColor = .blue
//
//        var stringAttributes = AttributeContainer()
//        stringAttributes.foregroundColor = .green
//
//        var commentAttributes = AttributeContainer()
//        commentAttributes.foregroundColor = .gray
//        commentAttributes.font = .italic(.body)()
//
//        // Tokenize and apply attributes
//        let tokens = swiftCode.split { !$0.isLetter && !$0.isNumber && $0 != "\"" && $0 != "/" && $0 != "*" }
//
//        for token in tokens {
//            if keywords.contains(String(token)) {
//                if let range = attributedString.range(of: String(token)) {
//                    attributedString[range].setAttributes(keywordAttributes)
//                }
//            } else if token.hasPrefix("\"") && token.hasSuffix("\"") {
//                if let range = attributedString.range(of: String(token)) {
//                    attributedString[range].setAttributes(stringAttributes)
//                }
//            } else if token.hasPrefix("//") || token.hasPrefix("/*") {
//                if let range = attributedString.range(of: String(token)) {
//                    attributedString[range].setAttributes(commentAttributes)
//                }
//            }
//        }
//
//        self = attributedString
//    }
// }

extension AttributedString {
    init(swiftCode: String) {
        self.init(stringLiteral: swiftCode)
        
        // Define attributes for syntax highlighting
        let keywords: Set<String> = ["let", "var", "func", "return", "if", "else", "for", "while", "class", "struct", "enum", "import", "switch", "case", "default", "guard", "in", "where", "protocol", "extension"]
        let types: Set<String> = ["Int", "Double", "Float", "String", "Bool", "Array", "Dictionary", "Set"]
        
        var keywordAttributes = AttributeContainer()
        keywordAttributes.foregroundColor = .blue
        
        var typeAttributes = AttributeContainer()
        typeAttributes.foregroundColor = .purple
        
        var stringAttributes = AttributeContainer()
        stringAttributes.foregroundColor = .green
        
        var commentAttributes = AttributeContainer()
        commentAttributes.foregroundColor = .gray
//        commentAttributes.font = .italicSystemFont(ofSize: UIFont.systemFontSize)
        
        var numberAttributes = AttributeContainer()
        numberAttributes.foregroundColor = .orange
        
        // Regular expressions for matching
        let keywordPattern = "\\b(" + keywords.joined(separator: "|") + ")\\b"
        let typePattern = "\\b(" + types.joined(separator: "|") + ")\\b"
        let stringPattern = "\"[^\"\\n]*\""
        let commentPattern = "//.*|/\\*[\\s\\S]*?\\*/"
        let numberPattern = "\\b\\d+(\\.\\d+)?\\b"
        
        // Apply attributes using regular expressions
        self.applyAttributes(with: keywordPattern, attributes: keywordAttributes)
        self.applyAttributes(with: typePattern, attributes: typeAttributes)
        self.applyAttributes(with: stringPattern, attributes: stringAttributes)
        self.applyAttributes(with: commentPattern, attributes: commentAttributes)
        self.applyAttributes(with: numberPattern, attributes: numberAttributes)
    }
    
    mutating func applyAttributes(with pattern: String, attributes: AttributeContainer) {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(self.startIndex ..< self.endIndex, in: self)
            
            regex.enumerateMatches(in: self.description, options: [], range: range) { match, _, _ in
                if let matchRange = match?.range {
                    if let range = Range(matchRange, in: self) {
                        self[range].setAttributes(attributes)
                    }
                }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
    }
}
