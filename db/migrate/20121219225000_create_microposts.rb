class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.string :string
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, :user_id
  end
end
