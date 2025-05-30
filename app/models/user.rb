class User < ApplicationRecord
    has_secure_password #パスワードをハッシュ化

    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true} #uniqueness: trueは重複しないようにする

    def posts #ユーザーと紐づいている投稿を返す
        return Post.where(user_id: self.id) 
    end
end
