class CreateLikesTable < ActiveRecord::Migration
  def change
    create_table :likes do |t|
    t.integer :post_id  
    t.integer :user_id 
    t.timestamps :created_at, null: false
  end
  end
end
