// app/actions.ts
"use server";

import Ably from "ably";
import {
  BaseRealtime,
  WebSocketTransport,
  FetchRequest,
  RealtimePresence,
} from "ably/modular";

const apiKey = process.env.API_KEY;
const channelName = process.env.CHANNEL_NAME ?? "streamui";

const client = new BaseRealtime({
  key: apiKey,
  plugins: {
    WebSocketTransport,
    FetchRequest,
    RealtimePresence,
  },
});

// const ably = new Ably.Realtime(apiKey);

let channel =
  client.channels.get(channelName); /* inferred type Ably.RealtimeChannel */

export async function publishEmoji(emoji: string) {
  console.log("Publishing emoji to Ably channel...");
  // const channel = ably.channels.get(channelName);
  await channel.publish("message", emoji);
  console.log(`Emoji "${emoji}" sent to Ably channel.`);
}
