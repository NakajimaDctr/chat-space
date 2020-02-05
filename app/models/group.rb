class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages
  validates :name, presence: true, uniqueness: true

  def show_last_message
    # グループに紐づくメッセージから最新のメッセージを取得
    last_message = messages.order("created_at DESC").first

    # 最新のメッセージが存在する場合
    if last_message.present?

      # 最新のメッセージがテキストの場合
      if last_message.content?
        # テキストの内容を返す
        last_message.content
      
      # 最新のメッセージが画像の場合
      else
        '画像が投稿されています'
      end
    
    # 最新のメッセージが存在しない場合
    else
      'まだメッセージはありません'
    end
  end
  def show_member
    members_array = []
    users.each do |user|
      members_array << user.name
    end
    members = members_array.join(", ")
  end

end
