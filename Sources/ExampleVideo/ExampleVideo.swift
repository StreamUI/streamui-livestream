//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/27/24.
//
import StreamUI
import SwiftUI

let width = 1920.0
let height = 1080.0

public struct ExampleVideo: View {
    @Environment(\.recorder) private var recorder

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            HStack(spacing: 0) {
                CodingView()
                    .frame(width: (2/3) * width, height: height)
                    .background(Color.lightGray)

                ChoiceView(people: people)
                    .frame(width: (1/3) * width, height: height)
            }

            .background(.white)
//                .position(x: width * 0.15, y: height / 2)
//                .offset(x: width * 0.7, y: -height / 2)
//                .animation(Animation.linear(duration: 10).delay(0))

//            SyntaxHighlightedText(code: """
//            import SwiftUI
//
//            struct ContentView: View {
//                var body: some View {
//                    Text("Hello, World!")
//                }
//            }
//
//            // This is a comment
//            /* This is another comment */
//            let example = "This is a string"
//            """)
        }
        .background(Color.white)
    }
}

extension Color {
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
}
