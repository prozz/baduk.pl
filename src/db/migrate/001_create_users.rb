class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string, :null => false
      t.column :password, :string, :null => false
      t.column :email, :string, :null => false
      t.column :number_of_logins, :integer, :null => false, :default => 0
      t.column :last_login_at, :datetime, :null => true 
      t.column :created_at, :datetime, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
