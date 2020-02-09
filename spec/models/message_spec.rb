require 'rails_helper'
RSpec.describe Message, type: :model do
  describe '#create' do
    context 'can save' do
      # 1. メッセージがあれば保存できる
      it "is valid with a content" do
        # imageが空のダミーインスタンスを生成
        message = build(:message, image: nil)

        # バリデーション結果のチェック
        expect(message).to be_valid
      end
      
      # 2. 画像があれば保存できる
      it "is valid with a image" do
        # contentが空のダミーインスタンスを生成
        message = build(:message, content: nil)

        # バリデーション結果のチェック
        expect(message).to be_valid
      end
      
      # 3. メッセージと画像があれば保存できる
      it "is valid with a content, image" do
        # ダミーインスタンスを生成
        message = build(:message)

        # バリデーション結果のチェック
        expect(message).to be_valid
      end
    end
      
    context 'can not save' do
      # 4. メッセージも画像もないと保存できない
      it "is invalid without a content, image" do
        # contentとimageが空のダミーインスタンスを生成
        message = build(:message, content: nil, image: nil)

        # バリデーションを実行
        message.valid?

        # バリデーション結果のチェック
        expect(message.errors[:content]).to include("を入力してください")
      end
      
      # 5. group_idがないと保存できない
      it "is invalid without a group_id" do
        # groupが空のダミーインスタンスを生成
        message = build(:message, group: nil)

        # バリデーションを実行
        message.valid?
    
        # バリデーション結果のチェック
        expect(message.errors[:group]).to include("を入力してください")
      end
      
      # 6. user_idがないと保存できない
      it "is invalid without a user_id" do
        # groupが空のダミーインスタンスを生成
        message = build(:message, user: nil)

        # バリデーションを実行
        message.valid?
    
        # バリデーション結果のチェック
        expect(message.errors[:user]).to include("を入力してください")
      end
    end
  end
end