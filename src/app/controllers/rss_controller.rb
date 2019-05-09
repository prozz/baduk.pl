class RssController < ApplicationController
  def recent_games # {{{ 
    headers["Content-Type"] = "application/xml" 
    @games = Game.find_recent
    render :layout => false
  end # }}}
  def recent_comments # {{{ 
    headers["Content-Type"] = "application/xml" 
    @comments = Comment.find_recent  
    render :layout => false
  end # }}}
end
