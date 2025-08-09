import consumer from "./consumer";

const chatRoomId = document.getElementById("chat-message-textarea").dataset.chatRoomId;

const chatRoomChannel = consumer.subscriptions.create(
  { channel: "RmdChatRoomChannel", room_id: chatRoomId },
  {
    received(data) {
      const chatMessages = document.getElementById("rmd-chat-messages");
      chatMessages.insertAdjacentHTML("beforeend", data.chat_message_html);
      document.getElementById("chat-bottom").scrollIntoView({ behavior: "smooth" });

      if (data.type === "force_exit") {
        alert(data.message);
        window.location.href = "/";
      }
    },

    speak(chatMessage, chatRoomId) {
      this.perform("speak", { chat_message: chatMessage, chat_room_id: chatRoomId });
    },
  }
);

// 送信イベント
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("chat-form");
  const textarea = document.getElementById("chat-message-textarea");

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const message = textarea.value.trim();
    if (message.length === 0) return;

    chatRoomChannel.speak(message, chatRoomId);
    textarea.value = "";
  });
});
