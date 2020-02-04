class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 認証済みのユーザーのみ、アクション内の処理を実行可能
  before_action :authenticate_user!
  # deviseコントローラーの場合のみ実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  # サインアップ（新規登録）の際にnameも許容する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    
  end
end
