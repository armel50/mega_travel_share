class CreateFriendshipsTable < ActiveRecord::Migration
  def change
    create_table :friendships do |t| 
      t.integer :follower_id 
      t.integer :following_id 
      t.timestamps :created_at, null: false
      t.timestamps :updated_at, null: false
    end
  end
end
