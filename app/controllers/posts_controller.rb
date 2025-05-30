class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index #投稿一覧
    @posts = Post.all.order(created_at: :desc)
  end

  def show #投稿詳細
    @post = Post.find_by(id: params[:id]) #urlのidと等しいデータを取得
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count #いいね数
  end

  def new
    @post = Post.new
  end

  def create #新規投稿
    @post = Post.new(
      content: params[:content], #ここのparamsは「name="○○"」が付いたフォームの入力内容を受け取る
      user_id: @current_user.id
      ) 
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index") #他のURLへ転送
    else
      render("posts/new", status: :unprocessable_entity)
    end
  end

  def edit #投稿編集
    @post = Post.find_by(id: params[:id])
  end

  def update #投稿更新
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました" #一度だけ表示する
      redirect_to("/posts/index")
    else
      #render("フォルダ名/ファイル名")、他のアクションを経由しないでビューを表示。つまり、renderを使用しているアクションの内容を含める
      render("posts/edit", status: :unprocessable_entity) #status: :unprocessable_entityはエラーが起きたと判断する
    end
    
  end

  def destroy #投稿削除
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user #投稿に紐づくユーザーと現在ログインしているユーザーが異なるかどうかを比べる
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
