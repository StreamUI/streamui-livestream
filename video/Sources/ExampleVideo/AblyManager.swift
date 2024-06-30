import Ably
import Observation
import SwiftUI

@Observable
class AblyManager {
    private var client: ARTRealtime!
    private var channel: ARTRealtimeChannel!
    private var continuation: AsyncStream<String>.Continuation?

    var messageStream: AsyncStream<String> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    init() {
        self.client = ARTRealtime(key: ENV.API_KEY)
        self.channel = self.client.channels.get(ENV.CHANNEL)

        // Subscribe to messages
        self.channel.subscribe { message in
            DispatchQueue.main.async {
                print("got message", message)
                self.continuation?.yield(message.data as? String ?? "Unknown message")
            }
        }
    }

    func sendMessage(_ message: String) {
        self.channel.publish("message", data: message)
    }
}
