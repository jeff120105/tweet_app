class Post < ApplicationRecord
    validates :content, {presence: true, length: {maximum: 140}} #空の投稿がデータベースに保存されない、141以上も保尊されない
    validates :user_id, {presence: true}

    def user #インスタンスメソッド
        return User.find_by(id: self.user_id) #selfはインスタンス自身をさす
    end
end
