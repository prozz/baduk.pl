
class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_baduk_session_id'
  include LoginSystem 
  
  before_filter :login_from_cookie

  layout 'core'

  def index
  end

  protected

  # adapted to rails 1.2.3, original: http://sean.treadway.info/responds-to-parent/
  def respond_to_parent script # {{{
      # We're returning HTML instead of JS or XML now
      response.headers['Content-Type'] = 'text/html; charset=UTF-8'

      # Escape quotes, linebreaks and slashes, maintaining previously escaped slashes
      # Suggestions for improvement?
      script = (script || '').
        gsub('\\', '\\\\\\').
        gsub(/\r\n|\r|\n/, '\\n').
        gsub(/['"]/, '\\\\\&').
        gsub('</script>','</scr"+"ipt>')

      # Eval in parent scope and replace document location of this frame
      # so back button doesn't replay action on targeted forms
      # loc = document.location to be set after parent is updated for IE
      # with(window.parent) - pull in variables from parent window
      # setTimeout - scope the execution in the windows parent for safari
      # window.eval - legal eval for Opera
      render :text => "<html><body><script type='text/javascript' charset='utf-8'>
        var loc = document.location;
        with(window.parent) { 
          setTimeout(function() { 
            window.eval('#{script}'); 
            if (window.loc) { loc.replace('about:blank'); }
          }, 1) 
        }
      </script></body></html>"
  end # }}}

  def escape_javascript(javascript)
    (javascript || '').gsub('\\','\0\0').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
  end

  def login_from_cookie
    return unless cookies[:auth_token] && session[:user].nil?
    user = User.find_by_remember_token(cookies[:auth_token]) 
    if user && !user.remember_token_expires.nil? && Time.now < user.remember_token_expires 
       session[:user] = user
    end
  end
  
end



