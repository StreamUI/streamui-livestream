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

let shortAudioURL = URL(string: "http://commondatastorage.googleapis.com/codeskulptor-assets/week7-brrring.m4a")!

public struct ExampleVideo: View {
    @Environment(\.recorder) private var recorder
    
    @State private var ablyManager = AblyManager()

    public init() {}
    
    @State private var emojis: [EmojiView] = []
    private let emojiArray = [
        "🌟", "💫", "✨", "⭐️", "⚡️", "🌈", "🌹", "🌺", "🌸", "🎉",
        "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇",
        "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚",
        "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🤫", "🤔",
        "🤐", "🤨", "😐", "😑", "😶", "😏", "😒", "🙄", "😬", "🤥",
        "😌", "😔", "😪", "🤤", "😴", "😷", "🤒", "🤕", "🤢", "🤮",
        "🤧", "🥵", "🥶", "🥴", "😵", "🤯", "🤠", "🥳", "😎", "🤓",
        "🧐", "😕", "😟", "🙁", "😮", "😯", "😲", "😳", "🥺", "😦",
        "😧", "😨", "😰", "😥", "😢", "😭", "😱", "😖", "😣", "😞",
        "😓", "😩", "😫", "🥱", "😤", "😡", "😠", "🤬", "😈", "👿",
        "💀", "☠️", "💩", "🤡", "👹", "👺", "👻", "👽", "👾", "🤖",
        "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "🙌",
        "👏", "👋", "🤚", "🖐", "✋", "🖖", "👌", "✌️", "🤞", "🤟",
        "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "👍", "👎",
        "✊", "👊", "🤛", "🤜", "🤚", "👐", "🙏", "✍️", "💅", "🤳",
        "💪", "🦾", "🦿", "🦵", "🦶", "👣", "👀", "👁", "👅", "👄",
        "🧠", "🫀", "🫁", "🦷", "🦴", "👤", "👥", "👶", "🧒", "👦",
        "👧", "🧑", "👱‍♂️", "👱‍♀️", "👨", "👩", "🧔", "👨‍🦰", "👨‍🦱", "👨‍🦳",
        "👨‍🦲", "👩‍🦰", "👩‍🦱", "👩‍🦳", "👩‍🦲", "🧓", "👴", "👵", "🙍", "🙍‍♂️",
        "🙍‍♀️", "🙎", "🙎‍♂️", "🙎‍♀️", "🙅", "🙅‍♂️", "🙅‍♀️", "🙆", "🙆‍♂️", "🙆‍♀️",
        "💁", "💁‍♂️", "💁‍♀️", "🙋", "🙋‍♂️", "🙋‍♀️", "🧏", "🧏‍♂️", "🧏‍♀️", "🙇",
        "🙇‍♂️", "🙇‍♀️", "🤦", "🤦‍♂️", "🤦‍♀️", "🤷", "🤷‍♂️", "🤷‍♀️", "🧑‍⚕️", "👨‍⚕️",
        "👩‍⚕️", "🧑‍🎓", "👨‍🎓", "👩‍🎓", "🧑‍🏫", "👨‍🏫", "👩‍🏫", "🧑‍⚖️", "👨‍⚖️", "👩‍⚖️",
        "🧑‍🌾", "👨‍🌾", "👩‍🌾", "🧑‍🍳", "👨‍🍳", "👩‍🍳", "🧑‍🔧", "👨‍🔧", "👩‍🔧", "🧑‍🏭",
        "👨‍🏭", "👩‍🏭", "🧑‍💼", "👨‍💼", "👩‍💼", "🧑‍🔬", "👨‍🔬", "👩‍🔬", "🧑‍💻", "👨‍💻",
        "👩‍💻", "🧑‍🎤", "👨‍🎤", "👩‍🎤", "🧑‍🎨", "👨‍🎨", "👩‍🎨", "🧑‍✈️", "👨‍✈️", "👩‍✈️",
        "🧑‍🚀", "👨‍🚀", "👩‍🚀", "🧑‍🚒", "👨‍🚒", "👩‍🚒", "👮", "👮‍♂️", "👮‍♀️", "🕵️",
        "🕵️‍♂️", "🕵️‍♀️", "💂", "💂‍♂️", "💂‍♀️", "👷", "👷‍♂️", "👷‍♀️", "🤴", "👸",
        "👳", "👳‍♂️", "👳‍♀️", "👲", "🧕", "🤵", "🤵‍♂️", "🤵‍♀️", "👰", "👰‍♂️",
        "👰‍♀️", "🤰", "🤱", "👩‍🍼", "👨‍🍼", "🧑‍🍼", "👼", "🎅", "🤶", "🧑‍🎄",
        "🦸", "🦸‍♂️", "🦸‍♀️", "🦹", "🦹‍♂️", "🦹‍♀️", "🧙", "🧙‍♂️", "🧙‍♀️", "🧚",
        "🧚‍♂️", "🧚‍♀️", "🧛", "🧛‍♂️", "🧛‍♀️", "🧜", "🧜‍♂️", "🧜‍♀️", "🧝", "🧝‍♂️",
        "🧝‍♀️", "🧞", "🧞‍♂️", "🧞‍♀️", "🧟", "🧟‍♂️", "🧟‍♀️", "🧌", "💆", "💆‍♂️",
        "💆‍♀️", "💇", "💇‍♂️", "💇‍♀️", "🚶", "🚶‍♂️", "🚶‍♀️", "🧍", "🧍‍♂️", "🧍‍♀️",
        "🧎", "🧎‍♂️", "🧎‍♀️", "🧑‍🦯", "👨‍🦯", "👩‍🦯", "🧑‍🦼", "👨‍🦼", "👩‍🦼", "🧑‍🦽",
        "👨‍🦽", "👩‍🦽", "🏃", "🏃‍♂️", "🏃‍♀️", "💃", "🕺", "🕴️", "👯", "👯‍♂️"
    ]
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Title and Subtitle
                VStack(alignment: .center) {
                    Text("This live streamed video is an app running on my server")
                        .font(.system(size: 45, weight: .black))
                    Text("Its a SwiftUI app running & generating the video in real time and then streaming to Youtube")
                        .font(.system(size: 30, weight: .medium))
                    Text("〜StreamUI is an open source library for creating videos with code in SwiftUI. \nYou can define video templates with SwiftUI to generate dynamic videos for Tiktok, Youtube, Instagram, etc. \nYou can also live stream the videos anywhere as well. ")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(width: 1920, height: 300)
                .background(Color.white)
                .padding()
                
                HStack {
                    LinkPreview(url: URL(string: "https://github.com/StreamUI/StreamUI")!)
                        .padding()
                        .frame(width: width / 2)
                    
                    Spacer()
                    
                    // QR Code and small text
                    VStack(spacing: 10) {
//                        Image(systemName: "qrcode") // Replace with actual QR code
                        StreamingImage(url: URL(string: "https://i.imgur.com/elO0OLd.png")!)
                            .frame(width: 500, height: 500)
                            .background(Color.white)
                        Text("Scan this QR code to send emojis to this live stream")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .frame(width: width / 2)
                }
                .frame(height: 500)
                
                Spacer()
                
                // Row along the bottom
                HStack {
                    SystemInfoView()
                }
                .frame(width: 1920, height: 300)
            }
            .background(Color.white)
            .foregroundColor(.black)
            
            // Emoji rain effect
            ForEach(emojis) { emoji in
                emoji
            }
        }
        .onAppear {
            Task {
                await startEmojiRain()
            }
            
            Task {
                try await startFakeRain()
            }
        }
    }
    
    private func startEmojiRain() async {
        print("fake start emoji")
        for await message in ablyManager.messageStream {
            print("adding")
            addEmoji(emoji: message)
        }
    }
    
    private func startFakeRain() async throws {
        print("fake wtf")
        while true {
            print("fake")
            let emoji = emojiArray.randomElement() ?? "🎉"
            print("adding fake rain", emoji)
            addEmoji(emoji: emoji)
            try await recorder?.controlledClock.clock.sleep(for: .seconds(3.5))
        }
    }
    
    private func playMusic() {
        recorder?.playAudio(from: shortAudioURL)
    }
    
    private func addEmoji(emoji: String) {
//        let emoji = emojiArray.randomElement() ?? "🎉"
        let startX = CGFloat.random(in: 0 ... width)
        let endY = height + 50
        let emojiView = EmojiView(emoji: emoji, startX: startX, endY: endY)
        emojis.append(emojiView)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if let index = emojis.firstIndex(where: { $0.id == emojiView.id }) {
                emojis.remove(at: index)
            }
        }
            
//            do {
//                try await recorder?.controlledClock.clock.sleep(for: .seconds(1.0))
//            } catch {
//                print("Clock sleep error: \(error)")
//            }
    }
}

struct EmojiView: View, Identifiable {
    @Environment(\.recorder) private var recorder
    
    let id = UUID()
    let emoji: String
    let startX: CGFloat
    let endY: CGFloat
    
    @State private var position: CGPoint = .zero
    
    var body: some View {
        Text(emoji)
            .font(.system(size: 50, weight: .black))
            .foregroundColor(.black)
            .position(position)
            .onAppear {
                position = CGPoint(x: startX, y: -50)
                Task {
                    await animateEmoji()
                }
            }
    }
    
    private func animateEmoji() async {
        guard let controlledClock = recorder?.controlledClock else { return }
        
        let duration = 4.0
        let steps = 60
        let stepDuration = duration / Double(steps)
        let stepDistance = (endY + 50) / CGFloat(steps)
        
        for step in 0 ..< steps {
            let newY = -50 + stepDistance * CGFloat(step)
//            await controlledClock.sleep(for: 1.0)
            try? await controlledClock.clock.sleep(for: .seconds(stepDuration))
            withAnimation(.linear(duration: stepDuration)) {
                position = CGPoint(x: startX, y: newY)
            }
        }
        
        // Move to final position
        try? await controlledClock.clock.sleep(for: .seconds(stepDuration))
        withAnimation(.linear(duration: stepDuration)) {
            position = CGPoint(x: startX, y: endY)
        }
    }
}

extension Color {
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
}
