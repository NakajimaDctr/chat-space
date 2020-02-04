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

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
