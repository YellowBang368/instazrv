class AllowEmailToBeNull < ActiveRecord::Migration[5.1]
  def self.up
    change_column :users, :email, :string, null: true
    change_column_default(:users, :email, nil)
  end

  def self.down
    change_column :users, :email, :string, null: false, default: ""
  end
end
