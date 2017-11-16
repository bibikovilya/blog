class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.text :body, null: false
      t.cidr :ip, null: false
      t.timestamps
    end
  end
end
