class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t| 
      t.string :title 
      t.text :description 
      t.integer :user_id 
      t.string :picture
      t.timestamps  :created_at ,null: false
      t.timestamps :update_at, null: false
    end
  end
end
