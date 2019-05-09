class Game < ActiveRecord::Base

  acts_as_taggable
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  has_many :comments

  # validates_length_of :sgf, :within => 1..6000, :too_long => "Plik SGF jest za długi.", :too_short => "Podaj zawartość pliku SGF"
  validates_length_of :description, :within => 1..100, :too_long => "Opis gry jest za długi.", :too_short => "Podaj opis gry"
  validates_presence_of :description, :on => :save, :message => "Podaj opis"
  validates_presence_of :sgf, :on => :save, :message => "Podaj zawartość pliku SGF"
  validates_presence_of :owner, :on => :save
  
  before_create :fill_uploaded_at

  def self.find_recent
    self.find(:all, :include => :owner, :order => "uploaded_at desc", :limit => 10)
  end

  def self.find_recent_for_user owner_id
    self.find(:all, :conditions => ["owner_id = ?", owner_id], :order => "uploaded_at desc", :limit => 4)
  end

  def self.paginate_for_user owner_id, page = 1
    self.paginate(:all, :order => "uploaded_at desc", :conditions => ["owner_id = ?", owner_id], :page => page)
  end
  
  def self.validate_sgf sgf
    not sgf.nil? and sgf.with_eols_removed.match(/^\(;(.*)(;B|W\[\w{2}\])+(.*)\)$/)
  end
   
  def self.per_page
    8 
  end

  protected
  def fill_uploaded_at
    self.uploaded_at = Time.now
  end

end
