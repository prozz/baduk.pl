class Rank < ActiveRecord::Base

  def self.find_ordered
    self.find(:all, :order => 'order_id')
  end

  # enum like class, so we use this for convinience
  def to_s
    self.value
  end
end
