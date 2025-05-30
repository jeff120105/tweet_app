class ApplicationController < ActionController::Base
    before_action :set_current_user #ここでは全コントローラー、全アクションでメソッドを定義できる

    def set_current_user
        @current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user #ログインしているユーザーがいるか確認
        if @current_user == nil
            flash[:notice] = "ログインが必要です"
            redirect_to("/login")
        end
    end

    def forbid_login_user #ログインしている人の制限するページ
        if @current_user
            flash[:notice] = "すでにログインしています"
            redirect_to("/posts/index")
        end
    end
end
