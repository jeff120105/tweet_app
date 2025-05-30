class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index #ユーザー一覧
    @users = User.all #ユーザーのデータをすべて取得
  end

  def show #ユーザー詳細
    @user = User.find_by(id: params[:id])
  end

  def new #ユーザー登録
    @user = User.new
  end

  def create #ユーザー登録、データベース保存
    @user = User.new(
      name: params[:name],
       email: params[:email],
       image_name: "default_user.jpg",
       password: params[:password]
       )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new", status: :unprocessable_entity)
    end
  end

  def edit #ユーザー編集
    @user = User.find_by(id: params[:id])
  end

  def update #ユーザー編集、データベース更新
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]

    if params[:image] #画像が送信されたら。
      @user.image_name = "#{@user.id}.jpg" #画像をuserのidの名前に変更、上書き
      image = params[:image] #フォームから送信された画像データをimageに代入
      #(ファイルの場所, ファイルの中身)画像ファイルを作成。画像が特殊なテキストより、binwrite。readで画像を読み込む。
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      #status: :unprocessable_entityを追加することで再表示する
      render("users/edit", status: :unprocessable_entity)
    end
  end

  def login_form

  end

  def login
    #emailとpasswordが一致するデータを取得
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password]) #authenticateは、()の中をハッシュ化し、@userのpassword_digestと一死するかどうか判定する
      session[:user_id] = @user.id #ブラウザにidを保存できるため、ユーザーidの情報を保つことが出来る
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form", status: :unprocessable_entity)
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i #編集ページのidとログインidが一致しない時の処理
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end
end

