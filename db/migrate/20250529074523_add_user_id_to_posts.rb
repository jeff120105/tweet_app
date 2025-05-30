class AddUserIdToPosts < ActiveRecord::Migration[7.0]
  def change
    #各投稿に「どのユーザーがその投稿を作成したか」という情報を持たせるため
    add_column :posts, :user_id, :integer
  end
end
