class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :name, :string, :null => false
      t.column :surname, :string, :null => false
      t.column :email, :string, :null => false
      t.column :rank, :string, :null => false  
      t.column :created_at, :datetime, :null => false

      t.column :secret_code, :string, :null => false
      t.column :is_confirmed, :boolean, :null => false, :default => 'f'
      t.column :is_removed, :boolean, :null => false, :default => 'f'
    end
  end

  def self.down
    drop_table :players
  end
end
