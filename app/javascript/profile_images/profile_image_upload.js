//profile_image_uploadという要素にイベント(change)が発生したら、
// function(e) {以下の処理を実行
$(document).on("change", "#profile_image_upload", function(e) {
    //ファイルの有無を判定
    if (e.target.files.length) {
      let reader = new FileReader;
      reader.onload = function(e) {
        //指定したクラスを削除
        $(".hidden").removeClass();
        $(".profile-default-img").removeClass();
        //指定した要素を削除
        $("#profile-img").remove();
        //<img>タグのsrc属性にアップロードしたファイルを設定
        $("#profile-img-prev").attr("src", e.target.result);
      };
      //readAsDataURLメソッドは、指定されたファイルの読み込みを実行
      return reader.readAsDataURL(e.target.files[0]);
    }
  })
