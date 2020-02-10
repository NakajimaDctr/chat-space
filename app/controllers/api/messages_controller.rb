class Api::MessagesController < ApplicationController
  def index
    # 検索対象のグループを取得
    group = Group.find(params[:group_id])
    # 表示されている最新のメッセージのidを取得する
    last_message_id = params[:id].to_i
    # 最新のidよりも大きいidのメッセージを検索する
    @messages = group.messages.includes(:user).where("id > ?", last_message_id)
  end
end