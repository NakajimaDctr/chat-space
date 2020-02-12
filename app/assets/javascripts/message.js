$(function(){

  // 投稿データを元にhtmlを作成する
  function buildHTML(message){

    var html = `<div class='main-chat__messages__message-box' data-message-id=${message.id} >
                  <div class='main-chat__messages__message-box__sender-box'>
                    <div class='main-chat__messages__message-box__sender-box__sender-name'>
                      ${message.username}
                    </div>
                    <div class='main-chat__messages__message-box__sender-box__send-time'>
                      ${message.created_at}
                    </div>
                  </div>
                  <div class='main-chat__messages__message-box__message'>
                    <div class='main-chat__messages__message-box__message__content'>
                      ${message.content}
                    </div>`

    if(message.image){
      // 画像が存在する場合
      html = html + ` <div class='main-chat__messages__message-box__message__image'>
                        <img src=${message.image}>
                      </div>
                     </div>`;
    } else {
      // 画像が存在しない場合
      html = html + `  </div>
                     </div>`;
    }
    return html;
  }

  // 未表示のメッセージがあれば表示させる
  var reloadMessages = function() {

    // 表示されている最新のメッセージのidを取得する
    last_message_id = $('.main-chat__messages__message-box:last').data("message-id");

    // Ajaxの設定（表示すべきメッセージがないか検証する）
    $.ajax({
      // スラッシュで始めない→"/groups/id/api/messages"となる
      url: "api/messages",
      type: "GET",
      dataType: "json",
      // 最新のメッセージidを送る
      data: {id: last_message_id}
    })

    // 成功した場合、メッセージを追加する
    .done(function(messages){

      // 返ってきたデータが空でない（未表示のデータが存在する場合）
      if(messages.length !== 0){
        // 追加するHTML
        var insertHTML = '';

        // 追加するメッセージを1件ずつHTML化する
        $.each(messages, function(i, message){
          insertHTML += buildHTML(message)
        });

        // メッセージ一覧エリアに追加する
        $(".main-chat__messages").append(insertHTML);

        // 最下部にスクロールさせる
      $('.main-chat__messages').animate({ scrollTop: $('.main-chat__messages')[0].scrollHeight});
      }
    })
    .fail(function(){
      alert("error");
    })
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

  // 表示しているページがメッセージ一覧画面の場合のみ自動更新を行う
  // 「/groups/グループid/messages」の場合のみ自動更新
  if(document.location.href.match(/\/groups\/\d+\/messages/)){
    setInterval(reloadMessages, 7000);
  }
});