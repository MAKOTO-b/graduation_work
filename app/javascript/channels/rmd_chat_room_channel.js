import consumer from "./consumer";

function setupChatRoom() {
  const root = document.getElementById("chat-root");
  if (!root) return;

  const chatRoomId    = parseInt(root.dataset.roomId, 10);
  const currentUserId = parseInt(root.dataset.userId, 10);
  const messagesEl    = document.getElementById("rmd-chat-messages");
  const bottomEl      = document.getElementById("chat-bottom");
  const form          = document.getElementById("chat-form");
  const ta            = document.getElementById("chat-message-textarea");

  if (window.rmdChatSub) window.rmdChatSub.unsubscribe();

  // ---- ActionCable購読 ----
  window.rmdChatSub = consumer.subscriptions.create(
    { channel: "RmdChatRoomChannel", room_id: chatRoomId },
    {
      received(data) {
        const fromMe = parseInt(data.sender_id, 10) === currentUserId;
        const html = fromMe ? data.mine_html : data.theirs_html;

        // ✅ bottomEl の直前に挿入（安全）
        bottomEl.insertAdjacentHTML("beforebegin", html);

        // ✅ 再描画が完了してからスクロール
        requestAnimationFrame(() => {
          bottomEl.scrollIntoView({ behavior: "instant" });
        });
      },
      speak(chatMessage) {
        this.perform("speak", {
          chat_message: chatMessage,
          chat_room_id: chatRoomId,
        });
      },
    }
  );

  // ---- メッセージ送信 ----
  if (form && !form.dataset.bound) {
    let composing = false;

    const sendMessage = () => {
      const msg = (ta.value || "").trim();
      if (!msg) return;
      window.rmdChatSub?.speak(msg);

      // 入力欄を初期化・高さリセット
      ta.value = "";
      ta.style.height = "auto";

      requestAnimationFrame(() => {
        bottomEl.scrollIntoView({ behavior: "instant" });
      });
    };

    // 送信ボタン
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      sendMessage();
    });

    // IME監視（日本語変換中はEnterを無効）
    ta.addEventListener("compositionstart", () => (composing = true));
    ta.addEventListener("compositionend", () => (composing = false));

    // Enter送信（Shift+Enterは改行）
    ta.addEventListener("keydown", (e) => {
      if (composing || e.isComposing || e.keyCode === 229) return;
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    });

    // 入力中は自動で高さ調整
    ta.addEventListener("input", () => {
      ta.style.height = "auto";
      ta.style.height = `${ta.scrollHeight}px`;
    });

    form.dataset.bound = "1";
  }
}

document.addEventListener("turbo:load", setupChatRoom);
