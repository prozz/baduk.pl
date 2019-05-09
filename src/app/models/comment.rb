class Comment < ActiveRecord::Base
  belongs_to :game
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  validates_length_of :comment, :within => 1..6000

  def self.find_recent
    self.find(:all, :include => :author, :order => "comments.created_at desc", :limit => 10)
  end

  def self.find_recent_for_user user_id
    self.find(:all, :conditions => ["author_id = ?", user_id], :order => "comments.created_at desc", :limit => 10)  
  end

  def self.find_eager game_id
    self.find(:all, :include => :author, :conditions => ["game_id = ?", game_id], :order => "comments.created_at asc")
  end
end
