class CreateGames < ActiveRecord::Migration
  
  def self.up
    create_table :games do |t|
      t.column :owner_id, :integer, :null => false
      t.column :description, :text, :null => true
      t.column :sgf, :text, :null => false
      t.column :uploaded_at, :datetime, :null => false
    end
  end

  def self.down
    drop_table :games
  end
end
