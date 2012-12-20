class RemoveColumns < ActiveRecord::Migration
  def up
  	remove_column :microposts, :string
  end

  def down
  end
end
