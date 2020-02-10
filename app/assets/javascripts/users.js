$(function(){

  // 検索結果エリア
  var user_list = $("#user-search-result");
  // メンバー表示エリア
  var member_list = $("#chat-group-users")

  // ユーザー１人分を表示
  function appendUser(user){
    // html作成
    var html = `<div class="chat-group-user clearfix">
                  <p class="chat-group-user__name">${user.name}</p>
                  <div class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id=${user.id} data-user-name=${user.name}>追加</div>
                </div>`

    // 検索結果表示エリアに追加
    user_list.append(html);
  }

  // エラーメッセージ表示
  function appendErrMsg(msg){
    // html作成
    var html = `<div class="chat-group-user clearfix">
                  <p class="chat-group-user__name">${msg}</p>
                </div>`

    // 検索結果表示エリアに追加
    user_list.append(html);
  }

  // メンバーを追加
  function appendMember(id, name){
    // html作成
    var html = `<div class="chat-group-user clearfix">
                  <input name='group[user_ids][]' type='hidden' value='${id}'>
                  <p class="chat-group-user__name">${name}</p>
                  <div class="user-search-add chat-group-user__btn chat-group-user__btn--remove" data-user-id=${id} data-user-name=${name}>削除</div>
                </div>`

    // 検索結果表示エリアに追加
    member_list.append(html);
  }

  // インクリメンタルサーチ
  $("#user-search-field").on("keyup", function(){
    // 入力文字列を取得する
    input = $(this).val();

    // Ajaxの設定
    $.ajax({
      url: "/users",
      type: "GET",
      data: { keyword: input },
      dataType: "json"
    })
    .done(function(users){
      // 検索結果を空にする
      user_list.empty();
      console.log(users);
      
      if(users.length != 0){
        // 検索結果１件ずつHTMLを追加
        users.forEach(function(user){
          appendUser(user);
        });
      }else{
        appendErrMsg("ユーザーが見つかりません");
      }
    })
    .fail(function(){
      alert("ユーザー検索に失敗しました")
    })
  })

  // メンバーを追加する
  // jsで追加した要素に対してはクリックイベントを感知できない
  // documentをクリック→指定した要素だったら処理を実行
  $(document).on("click", ".chat-group-user__btn--add", function(){

    // クリックされたユーザーのnameとidを取得する
    var id = $(this).attr("data-user-id");
    var name = $(this).attr("data-user-name");

    // メンバーを追加する
    appendMember(id, name)
    // 検索結果から対象のユーザーを除去
    $(this).parent().remove();
  })

  // メンバー削除
  $(document).on("click", ".chat-group-user__btn--remove", function(){
    $(this).parent().remove();
  })
})