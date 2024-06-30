import Image from "next/image";
import dynamic from "next/dynamic";

// Dynamically import EmojiList as a client component
const EmojiList = dynamic(() => import("./EmojiList"), {
  ssr: false,
});

export default function Home() {
  return (
    <main
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        height: "100vh",
      }}
    >
      <EmojiList />
    </main>
  );
}
