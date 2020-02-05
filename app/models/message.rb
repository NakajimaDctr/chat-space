class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # contentが空の場合登録できない（画像がない場合）
  validates :content, presence: true, unless: :image?

  mount_uploader :image, ImageUploader
  
end
