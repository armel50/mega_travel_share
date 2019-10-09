class User < ActiveRecord::Base
    # has_many :comments 
    has_many :posts 
    has_many :comments
    has_many :follower_relations, foreign_key: :following_id, class_name: "Friendship"
    has_many :followers, through: :follower_relations, source: :follower

    has_many :following_relations, foreign_key: :follower_id, :class_name => "Friendship" 
    has_many :followings, through: :following_relations,  source: :following
    has_secure_password


    # def follow(user_id)
    #     following_relations.create(following_id: user_id)
    #   end
    
    #   def unfollow(user_id)
    #     following_relations.find_by(following_id: user_id).destroy
    #   end
end