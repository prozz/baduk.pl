class CreateRanks < ActiveRecord::Migration
  def self.up

    create_table :ranks do |t|
      t.column :value, :string, :null => false
      t.column :order_id, :int, :null => false
    end

  end

  def self.down
    drop_table :ranks
  end
end
