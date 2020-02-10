$(function(){

  // 投稿データを元にhtmlを作成する
  function buildHTML(message){
    if(message.image){
      // 画像が存在する場合
      html = `<div class='main-chat__messages__message-box'>
                <div class='main-chat__messages__message-box__sender-box'>
                  <div class='main-chat__messages__message-box__sender-box__sender-name'>
                    ${message.username}
                  </div>
                  <div class='main-chat__messages__message-box__sender-box__send-time'>
                    ${message.created_at}
                  </div>
                </div>
                <div class='main-chat__messages__message-box__message'>
                  ${message.content}
                  <img src=${message.image}/>
                </div>
              </div>`;
    } else {
      // 画像が存在しない場合
      html = `<div class='main-chat__messages__message-box'>
                <div class='main-chat__messages__message-box__sender-box'>
                  <div class='main-chat__messages__message-box__sender-box__sender-name'>
                    ${message.username}
                  </div>
                  <div class='main-chat__messages__message-box__sender-box__send-time'>
                    ${message.created_at}
                  </div>
                </div>
                <div class='main-chat__messages__message-box__message'>
                  ${message.content}
                </div>
              </div>`;
    }
    return html;
  }

  // メッセージ送信処理（非同期通信）
  $("#new_message").on("submit", function(e){
    // デフォルトの処理を抑止
    e.preventDefault();

    // formを取得する（イベント発火元のフォーム）
    // 対象のform内に含まれるinput要素のvalueをハッシュで取得
    var formData = new FormData(this);

    // 送信先URLを取得
    var url = $(this).attr('action');

    // ajaxの設定
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      // メッセージ一覧にメッセージを追加する
      $(".main-chat__messages").append(buildHTML(data));

      // formの中身を空にする
      $('form')[0].reset();

      // 最下部にスクロールさせる
      $('.main-chat__messages').animate({ scrollTop: $('.main-chat__messages')[0].scrollHeight});

      // 送信ボタンを活性化
      $('.main-chat__form__new-message__submit').prop('disabled', false);
    })
    .fail(function(){
      // エラーメッセージ表示
      alert("メッセージ送信に失敗しました。")

      // 送信ボタンを活性化
      $('.main-chat__form__new-message__submit').prop('disabled', false);
    })
  })
});