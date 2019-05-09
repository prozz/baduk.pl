class Profile < ActiveRecord::BaseWithoutTable
  column :password
  column :password_confirmation  
  validates_length_of :password, :within => 5..40, :too_long => "Hasło jest za długie.", :too_short => "Hasło jest za krótkie (minimum 5 znaków)."
  validates_confirmation_of :password, :on => :create, :message => "Hasło nie zostało potwierdzone"
  validates_presence_of :password, :message => "Hasło nie może być puste."
end
