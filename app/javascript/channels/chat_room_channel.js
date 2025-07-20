import consumer from "./consumer"


const appChatRoom = consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    const chatMessages = document.getElementById("chat-messages");
    //document.getElementById('chat-messages');でid="chat-messages"の要素のオブジェクトを返す
    //insertAdjacentHTML で第2引数のdata['chat_message']を挿入する。挿入位置は、
    // 'beforeend'なので、element 内部の、最後の子要素の後に挿入する。
    chatMessages.insertAdjacentHTML("beforeend", data["chat_message"]);
  },

  //chat_room_channel.rbのspeakアクションへデータ送信
  speak: function(chat_message, chat_room_id) {
    return this.perform("speak", { chat_message: chat_message, chat_room_id: chat_room_id });
  }
});

//jqueryの機能
// keypress:キーボードのキーが押されたときのイベント
// keydown:キーボードのキーが押し込まれたときのイベント
// ボタンが押された時に変更できそう
  $(document).on("keypress", ".chat-room__message-form_textarea", function(e) {
    if (e.key === "Enter") {
      const chat_room_id = $("textarea").data("chat_room_id")
      appChatRoom.speak(e.target.value, chat_room_id);
      e.target.value = "";
      e.preventDefault();
    }
  })

