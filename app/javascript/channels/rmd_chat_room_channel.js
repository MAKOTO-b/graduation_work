import consumer from "./consumer"


const appRmdChatRoom = consumer.subscriptions.create("RmdChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    const RmdChatMessages = document.getElementById('rmd-chat-messages');
    //document.getElementById('chat-messages');でid="rmd-chat-messages"の要素のオブジェクトを返す
    //insertAdjacentHTML で第2引数のdata['rmd_chat_message']を挿入する。挿入位置は、
    // 'beforeend'なので、element 内部の、最後の子要素の後に挿入する。
    RmdChatMessages.insertAdjacentHTML('beforeend', data['rmd_chat_message']);
    window.scrollBy(0, 10000);
  },

  //rmd_chat_room_channel.rbのspeakアクションへデータ送信
  speak: function(rmd_chat_message, rmd_chat_room_id) {
    return this.perform('speak', { rmd_chat_message: rmd_chat_message, rmd_chat_room_id: rmd_chat_room_id });
  }
});

//jqueryの機能
// keypress:キーボードのキーが押されたときのイベント
// keydown:キーボードのキーが押し込まれたときのイベント
// ボタンが押された時に変更できそう
  $(document).on("keypress", ".rmd-chat-room__message-form_textarea", function(e) {
    if (e.key === "Enter") {
      const rmd_chat_room_id = $('textarea').data('rmd_chat_room_id')
      appRmdChatRoom.speak(e.target.value, rmd_chat_room_id);
      e.target.value = '';
      e.preventDefault();
    }
  })

