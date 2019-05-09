require File.dirname(__FILE__) + '/../test_helper'

class NotifictionsTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_signup
    @expected.subject = 'baduk.pl - Welcome!'
    @expected.body    = read_fixture('signup')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifictions.create_signup(@expected.date).encoded
  end

  def test_forgotten_password
    @expected.from    = 'service@baduk.pl'
    @expected.to      = 'test@bob.xyz.com'
    @expected.subject = 'baduk.pl - Your new password'
    @expected.body    = read_fixture('forgotten_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifictions.create_forgotten_password('test@bob.xyz.com', 'new password', @expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notifictions/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
