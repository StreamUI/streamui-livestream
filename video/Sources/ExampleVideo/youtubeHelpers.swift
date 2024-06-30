//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/29/24.
//

import Foundation
import SwiftUI

struct YouTubeViewCountView: View {
    @State private var viewCount: Int = 0
    @State private var timer: Timer?
    let updateInterval: TimeInterval = 30

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "play.rectangle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
            Text("Views: \(viewCount)")
                .font(.title)
        }
        .onAppear {
            fetchViewCount()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
            fetchViewCount()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func fetchViewCount() {
        Task {
            do {
                let count = try await getYouTubeVideoViewCount()
                DispatchQueue.main.async {
                    self.viewCount = count
                }
            } catch {
                print("Error fetching view count: \(error.localizedDescription)")
            }
        }
    }
}

func getYouTubeVideoViewCount(videoId: String = ENV.YOUTUBE_VIDEO_ID) async throws -> Int {
    let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&part=statistics&key=\(ENV.GOOGLE_API_KEY)"
    guard let url = URL(string: urlString) else {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
    }

    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let items = json["items"] as? [[String: Any]],
          let statistics = items.first?["statistics"] as? [String: Any],
          let viewCountString = statistics["viewCount"] as? String,
          let viewCount = Int(viewCountString)
    else {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
    }

    return viewCount
}
