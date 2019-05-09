require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :games

  validates_length_of :login, :within => 3..40, :too_long => "Nazwa użytkownika jest za długa.", :too_short => "Nazwa użytkownika jest za krótka."
  validates_length_of :password, :within => 5..40, :too_long => "Hasło jest za długie.", :too_short => "Hasło jest za krótkie."
  validates_length_of :email, :within => 5..40, :too_long => "Email jest za długi.", :too_short => "Email jest za krótki."
  validates_presence_of :login, :message => "Nazwa użytkownika jest wymagana."
  validates_presence_of :email, :message => "Email jest wymagany."
  validates_presence_of :password, :message => "Hasło nie może być puste."
  validates_uniqueness_of :login, :message => "Nazwa użytkownika jest zajęta."
  validates_uniqueness_of :email, :message => "Założono już konto z tym adresem email."
  validates_confirmation_of :password, :on => :create, :message => "Powtórzone hasło nie jest takie samo."    
  validates_format_of :login, :with => /\A[A-Za-z0-9_]*\Z/, :message => "Używaj liter, cyfr i znaku podkreślenia"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "Adres email nie jest poprawny."
  
  before_create :crypt_password
  
  def self.authenticate(login, pass)
    User.transaction {
      user = find(:first, :conditions => ["lower(login) = lower(?) AND password = ?", login, sha1(pass)])
      if not user.nil?
        user.number_of_logins = user.number_of_logins + 1
        user.last_login_at = Time.now
        user.update
      end
      user
    }
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end

  def remember_me
    self.remember_token_expires = 32.weeks.from_now
    self.remember_token = self.class.sha1(self.remember_token_expires)
    self.save_with_validation(false)
  end

  def forget_me
    self.remember_token_expires = nil
    self.remember_token = nil
    self.save_with_validation(false)
  end

  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("asdkfj34rjisadif--#{pass}--")
  end
    
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

end
