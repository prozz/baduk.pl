class Notifictions < ActionMailer::Base

  # FIXME: do we really need signup message?
  def signup(sent_at = Time.now)
    @subject    = 'baduk.pl - Welcome!'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end

  def forgotten_password(email, password, sent_at = Time.now)
    @subject    = 'baduk.pl - Nowe hasło'
    @body       = { :new_password => password }
    @recipients = email
    @from       = 'service@baduk.pl'
    @sent_on    = sent_at
  end

  def tournament_registration(email, player, sent_at = Time.now)
    @subject    = 'baduk.pl - Informacje turniejowe'
    @body       = { :player => player }
    @recipients = email
    @from       = 'service@baduk.pl'
    @sent_on    = sent_at
  end
end
