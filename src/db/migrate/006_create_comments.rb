class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :game_id, :integer, :null => false
      t.column :author_id, :integer, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :comment, :text, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
