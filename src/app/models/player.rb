require 'digest/sha1'

class Player < ActiveRecord::Base

  validates_presence_of :name, :message => 'Podaj swoje imię.'
  validates_presence_of :surname, :message => 'Podaj swoje nazwisko.'
  validates_presence_of :email, :message => 'Email jest niezbędny w celu potwierdzenia rejestracji.'
  validates_presence_of :rank, :message => 'Podaj swój ranking.'

  validates_length_of :name, :maximum => 25, :message => 'Zbyt długie imię'
  validates_length_of :surname, :maximum => 40, :message => 'Zbyt długie nazwisko'
  validates_length_of :email, :maximum => 40, :message => 'Email jest nieprawidłowy'
  validates_format_of :email, :if => :allow_validation_of_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => 'Email jest nieprawidłowy.'
  validates_format_of :rank, :with => /(\d\sdan)|(\d+\skyu)/, :message => 'Wybierz wartość z listy'

  validates_uniqueness_of :email, :message => 'Email zajęty.'

  before_create :fill_confirmation_fields

  def self.find_confirmed
    # TODO: nice order without those stupid joins
    Player.find(:all, :joins => 'join ranks r on rank = r.value', :conditions => ['is_confirmed = ?', true], :order => 'r.order_id, surname') 
  end

  protected
    def allow_validation_of_email
      not self.email.empty?
    end

    def fill_confirmation_fields
      self.secret_code = Digest::SHA1.hexdigest("asdkfj34rjisadif--#{UUID.new}--")
      self.is_confirmed = false
      self.is_removed = false
      return
    end
end
