//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/27/24.
//

import Combine
import SwiftUI

struct SyntaxHighlightedText: View {
    @Environment(\.recorder) private var recorder

    let code: String
    @State private var displayedText: String = ""
    @State private var displayedAttributedText: AttributedString = ""

    @State private var currentIndex: Int = 0
    @State private var isTyping: Bool = true

    var body: some View {
        VStack {
//            Text(AttributedString(swiftCode: displayedText))
            Text(displayedAttributedText)
                .font(.system(size: 10, design: .monospaced))
                .lineSpacing(-2) // Adjust the value to achieve the desired line spacing
                .onAppear {
                    Task {
                        await typeText()
                    }
                }
        }
        .padding()
    }

    func typeText() async {
        // Typing state
        isTyping = true

        displayedAttributedText = AttributedString()
        currentIndex = 0

//        let fullAttributedText = AttributedString(swiftCode: code)

        // Typing each character
//        for char in code {
//            displayedText.append(char)
//            displayedAttributedText = AttributedString(swiftCode: displayedText)
//
//            currentIndex += 1
//            try? await recorder?.controlledClock.clock.sleep(for: .milliseconds(5)) // Adjust typing speed as needed
//        }

        let typingSpeed: UInt64 = 5 // Adjust the speed as needed
        let charsPerFrame = 5 // Adjust the number of characters appended per frame

        // Typing each character
        var charIndex = 0
        while charIndex < code.count {
            let endIndex = min(charIndex + charsPerFrame, code.count)
            let range = code.index(code.startIndex, offsetBy: charIndex) ..< code.index(code.startIndex, offsetBy: endIndex)
            displayedText.append(contentsOf: code[range])
            displayedAttributedText = AttributedString(swiftCode: displayedText)

            currentIndex += charsPerFrame
            charIndex += charsPerFrame
//            try? await Task.sleep(nanoseconds: typingSpeed * 1_000_000) // Adjust typing speed as needed
            try? await recorder?.controlledClock.clock.sleep(for: .milliseconds(5))
        }

        // Score state
        isTyping = false
    }
}
