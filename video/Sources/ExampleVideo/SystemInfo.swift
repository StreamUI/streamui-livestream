//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/29/24.
//

import Combine
import Foundation
import SwiftUI
import SystemInfoKit

struct SystemInfoView: View {
    @Environment(\.recorder) private var recorder

    @State private var systemInfo: SystemInfoBundle?
    @State private var gpuUtilization: Double?
    @State private var youtubeViewCount: Double = 0
    @State private var fetchCount: Int = 0

    private var observer = SystemInfoObserver.shared(monitorInterval: 3.0)
    @State private var cancellables = Set<AnyCancellable>()

    var formattedElapsedTime: String {
        guard let recorder = recorder else { return "" }
        let elapsedTime = recorder.controlledClock.elapsedTime

        let hours = Int(elapsedTime) / 3600000
        let minutes = (Int(elapsedTime) % 3600000) / 60000
        let seconds = (Int(elapsedTime) % 60000) / 1000
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 100) {
            SectionView(icon: "play.rectangle.fill", title: "YouTube Views", count: Double(youtubeViewCount))

            if let recorder = recorder {
                SectionView(icon: "camera", title: "Frame Count", count: Double(recorder.frameTimer.frameCount))
                SectionView(icon: "clock", title: "Elapsed Time", details: [formattedElapsedTime])
            }

            if let info = systemInfo {
                if let cpuDetails = info.cpuInfo?.details {
                    SectionView(icon: "cpu.fill", title: "CPU Usage", details: cpuDetails)
                }

                if let gpuUtilization = gpuUtilization {
                    SectionView(icon: "m1.button.horizontal.fill", title: "GPU Utilization", count: gpuUtilization)
                }

                if let memoryDetails = info.memoryInfo?.details {
                    SectionView(icon: "memorychip", title: "Memory Usage", details: memoryDetails)
                }

                if let networkDetails = info.networkInfo?.details.dropFirst() {
                    SectionView(icon: "network", title: "Network Status", details: Array(networkDetails))
                }
            } else {
                Text("Fetching system information...")
            }
        }
        .padding()
        .onAppear(perform: startMonitoring)
        .onDisappear(perform: stopMonitoring)
    }

    private func startMonitoring() {
        observer.systemInfoPublisher
            .receive(on: DispatchQueue.main)
            .sink { info in
                self.systemInfo = info
                self.updateGPUUtilization()
                Task {
                    try await self.incrementFetchCount()
                }
            }
            .store(in: &cancellables)

        observer.startMonitoring()
    }

    private func stopMonitoring() {
        observer.stopMonitoring()
    }

    private func updateGPUUtilization() {
        if let utilization = getGPUUtilization()?["GPU Utilization"] {
            DispatchQueue.main.async {
                self.gpuUtilization = utilization
            }
        }
    }

    private func incrementFetchCount() async throws {
        fetchCount += 1
        if fetchCount % 3 == 0 {
            let viewCount = try await getYouTubeVideoViewCount()
            youtubeViewCount = Double(viewCount)
        }
    }
}

#Preview {
    SystemInfoView()
}

struct SectionView: View {
    let icon: String
    let title: String
    var count: Double? = nil
    var details: [String]? = nil

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.system(size: 25, weight: .bold))
            }
            if let count = count {
                Text(String(format: "%.2f", count))
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom, 10)
            }
            if let details = details {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(details, id: \.self) { detail in
                        Text(detail)
                            .font(.system(size: 20, weight: .medium))
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}
