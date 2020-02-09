require 'rails_helper'

describe MessagesController do

  # テスト中使用するダミーインスタンスを定義
  # createなのでDBに保存される
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do
    # ログイン状態の時
    context 'log in' do

      # コンテキスト内の各example実行前に実行する処理
      before do
        # ユーザーをログイン状態にする
        login user

        # letで定義されたgroupのidをparamsに設定して、indexメソッドを実行
        get :index, params: { group_id: group.id }
      end

      # indexメソッドを実行 → @messageの生成確認
      it 'assigns @message' do
        # @messageがMessageをnewしたものと一致していればOK
        expect(assigns(:message)).to be_a_new(Message)
      end

      # indexメソッドを実行 → @groupの生成確認
      it 'assigns @group' do
        # @groupがletで定義したgroupと一致していればOK
        expect(assigns(:group)).to eq group
      end

      # indexメソッドを実行 → viewを確認
      it 'renders index' do
        # indexのviewに遷移されていればOK
        # render_template → 引数で指定されたアクションがリクエストされた時に自動的に遷移するビューを返す
        expect(response).to render_template :index
      end
    end

    # ログアウト状態の時
    context 'not log in' do

       # コンテキスト内の各example実行前に実行する処理
       before do
        # letで定義されたgroupのidをparamsに設定して、indexメソッドを呼び出す
        get :index, params: { group_id: group.id }
      end

      # indexメソッドを実行 → redirect先を確認
      it 'redirects to new_user_session_path' do
        # リダイレクト先がログイン画面であればOK
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    # グループid、ユーザーid、メッセージのハッシュを持ったparamsを定義
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    # ログインしている場合
    context 'log in' do
      # ユーザーをログイン状態にしておく
      before do
        login user
      end

      # creteメソッド実行 → メッセージ登録に成功するパターン
      context 'can save' do
        # パラメータにparamsをセットし、postメソッドでcreateアクションを擬似的にリクエストする処理を定義
        subject {
          post :create,
          params: params
        }

        # createメソッドを実行 → Messageの総数を確認
        it 'count up message' do
          # subjectの結果、Messageの総数が1個増えたらOK
          expect{ subject }.to change(Message, :count).by(1)
        end

        # createメソッドを実行 → 遷移先を確認
        it 'redirect to group_message_path' do
          # subjectで定義した処理を呼び出す（createメソッド実行）
          subject

          # messageのindexのviewが表示されたらOK
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      # creteメソッド実行 → メッセージ登録に失敗するパターン
      context 'can not save' do
        # パラメータのmessageにはcontentもimageもない
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

        subject{
          post :create,
          params: invalid_params
        }

        # createメソッド実行 → Message総数を確認
        it 'does not cout up' do
          # subjectの結果、Messageの総数が増えていなかったらOK
          expect{ subject }.not_to change(Message, :count)
        end

        # createメソッドを実行 → 遷移先を確認
        it 'render index' do
          # createメソッド実行
          subject
          # indexへrenderされたらOK
          expect(response).to render_template :index
        end
      end
    end

    # ログアウトしている場合
    context 'not log in' do

      # createメソッドを実行 → 遷移先を確認
      it 'redirect to new_user_session_path' do
        # メッセージに正しくデータが入っている状態でcreateメソッドを実行
        post :create, params: params
        # ログイン画面に遷移したらOK
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
