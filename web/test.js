// publisher.js
const Ably = require("ably");

const apiKey = "0k1rMg.367oTA:Wm8Qp0whFBIOLQjTJRilNXvG-84O1SeZagsHyXTwmNo";
const channelName = "streamui";

// Initialize Ably Realtime client
const ably = new Ably.Realtime(apiKey);

// Get the channel
const channel = ably.channels.get(channelName);

// Function to publish a message
const publishMessage = (message) => {
  channel.publish("message", message, (err) => {
    if (err) {
      console.error("Failed to publish message:", err);
    } else {
      console.log("Message published:", message);
    }
  });
};

// Example usage

async function sendEm() {
  for (let i = 0; i < 100; i++) {
    console.log("sending message");
    publishMessage("🤯");
    await new Promise((resolve) => setTimeout(resolve, 5000));
  }
}

sendEm();
