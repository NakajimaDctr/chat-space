class GroupsController < ApplicationController
  def index
  end


  def new
    @group = Group.new
    @group.users << current_user
    
  end
  def create
    # 新規グループのインスタンス作成（送信時点の情報）
    # メンバー情報（user_ids）は@groupではなく、GroupUserモデルのインスタンスが保持する
    @group = Group.new(group_params)
    # 登録が成功したら、indexへ遷移する
    if @group.save
      redirect_to root_path, notice: 'グループを作成しました'
    else
      # 登録失敗の場合、グループ作成画面へ遷移する
      # 入力情報はグループ名とメンバーリスト→メンバーリストは@group内で保持しない
      # そのため、ここに来るのはグループ名がない場合。よってここにきた時、@groupは空となりnew画面の送信先はcreateとなる
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    # 更新対象のグループを取得
    @group = Group.find(params[:id])

    # 更新が完了したらindexへ遷移
    if @group.update(group_params)
      redirect_to  group_messages_path(@group.id), notice: 'グループを更新しました'
    else
      # 更新失敗したら更新画面へ遷移
      render :edit
    end
  end

  private
  def group_params
    # user_ids（配列）を許容する
    params.require(:group).permit(:name, user_ids: [])
  end
end
