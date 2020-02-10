class UsersController < ApplicationController
  def edit
  end

  def update
    # 更新処理が正常に終了したら、indexへ
    if current_user.update(user_params)
      redirect_to root_path
    else
      # 更新処理が失敗したら編集画面へ
      render :edit
    end
  end

  def index
    # 入力を元にユーザーを部分一致で検索（ログインユーザーは除く、上限10名）
    @users = User.where('name LIKE(?)', "%#{params[:keyword]}%").where.not(id: current_user.id).limit(10)
    respond_to do |format|
      format.json
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
