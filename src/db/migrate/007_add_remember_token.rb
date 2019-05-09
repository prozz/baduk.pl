class AddRememberToken < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_token, :text
    add_index :users, :remember_token, :unique => true
    add_column :users, :remember_token_expires, :datetime
  end

  def self.down
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires
  end
end
