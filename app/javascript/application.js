// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "./channels"
import "./profile_images/profile_image_upload"

document.addEventListener("turbo:before-visit", () => {
  // ページ遷移時にActionCableの接続を強制的に閉じる
  if (window.App && window.App.cable) {
    window.App.cable.disconnect();
  }
});