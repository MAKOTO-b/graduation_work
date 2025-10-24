import consumer from "./consumer";

function setupChatRoom() {
  const root = document.getElementById("chat-root");
  if (!root) return; // このページ以外では何もしない

  const chatRoomId    = parseInt(root.dataset.roomId, 10);
  const currentUserId = parseInt(root.dataset.userId, 10);
  const messagesEl    = document.getElementById("rmd-chat-messages");

  // 既存購読があれば解除してから作り直す（Turboによる二重購読対策）
  if (window.rmdChatSub) window.rmdChatSub.unsubscribe();

  window.rmdChatSub = consumer.subscriptions.create(
    { channel: "RmdChatRoomChannel", room_id: chatRoomId },
    {
      received(data) {
        const fromMe = parseInt(data.sender_id, 10) === currentUserId;
        const html   = fromMe ? data.mine_html : data.theirs_html;
        messagesEl.insertAdjacentHTML("beforeend", html);
        document.getElementById("chat-bottom").scrollIntoView({ behavior: "smooth" });
      },
      speak(chatMessage) {
        this.perform("speak", { chat_message: chatMessage, chat_room_id: chatRoomId });
      }
    }
  );

  // フォーム submit をチャネル送信に置き換える（Turbo 環境で一度だけ）
  const form = document.getElementById("chat-form");
  const ta   = document.getElementById("chat-message-textarea");

  if (form && !form.dataset.bound) {
    // 共通送信関数
    const sendMessage = () => {
      const msg = (ta.value || "").trim();
      if (!msg) return;
      window.rmdChatSub.speak(msg);
      ta.value = "";
      document.getElementById("chat-bottom")?.scrollIntoView({ behavior: "smooth" });
    };

    // 送信ボタン（form submit）で送信
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      sendMessage();
    });

    // Enterキーで送信（Shift+Enterは改行）
    ta.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    });
    form.dataset.bound = "1";
  }
}

document.addEventListener("turbo:load", setupChatRoom);
