class MessagesController < ApplicationController
  before_action :set_group

  def index
    # グループに投稿済みのメッセージ（投稿者と紐付けしておく）
    @messages = @group.messages.includes(:user)
    # 新規メッセージ用のMessageインスタンス
    @message = Message.new
  end

  def create
    # グループに紐づくMessageインスタンスを生成
    @message = @group.messages.new(message_params)

    # 登録が成功
    if @message.save

      # JSONでデータを返す
      respond_to do |format|
        format.json
      end
      
    else
      # 失敗した場合、indexへ遷移する
      @messages = @group.messages.includes(:user)
      flash.now[:alert] = 'メッセージを入力してください'
      render :index
    end
    
  end
  private
  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_group
    # パラメータを元に対象のグループを取得する
    @group = Group.find(params[:group_id])
  end
end
