class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t| 
      t.string :content 
      t.integer :post_id 
      t.integer :user_id 
      t.timestamps :created_at, null: false 
    end
  end
end
