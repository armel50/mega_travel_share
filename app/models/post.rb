class Post < ActiveRecord::Base
    belongs_to :user 
    has_many :comments
    has_many :likes 
    has_many :likers, foreign_key: :user_id,through: :likes, class_name: "User" , source: :user
end