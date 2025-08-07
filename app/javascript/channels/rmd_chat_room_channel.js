import consumer from "./consumer"

const roomId = document.getElementById("rmd-chat-room-id")?.dataset?.roomId;

const chatChannel = consumer.subscriptions.create(
  { channel: "RmdChatRoomChannel", room_id: roomId },
  {
    received(data) {
      const container = document.getElementById("rmd-chat-messages");
      container.insertAdjacentHTML("beforeend", data.chat_message);
    },

    speak(chat_message, chat_room_id, partner_id) {
      this.perform("speak", {
        chat_message: chat_message,
        chat_room_id: chat_room_id,
        partner_id: partner_id
      });
    }
  }
);

// イベントリスナー
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("chat-form");
  const input = document.getElementById("chat-input");
  const chatRoomId = form.dataset.roomId;
  const partnerId = form.dataset.partnerId;

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const message = input.value;
    if (message.trim() === "") return;

    chatChannel.speak(message, chatRoomId, partnerId);
    input.value = "";
  });
});