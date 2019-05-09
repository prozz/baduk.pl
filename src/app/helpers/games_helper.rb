module GamesHelper
  
  # escape properly and apply new lines as expected by comment's author
  def show_comment comment
    buf = h(comment.comment)
    buf.gsub!(/\n/, '<br/>')
    buf.gsub!(/@(\d+)/, '<a href="#" onclick="javascript:window.player.goTo(\1,true);return false;">@\1</a>')
    buf.gsub!(/#(\d+)/, '<a href="/games/show/\1">#\1</a>')
    return buf
  end
  
  def ads game
    buf = ''
    if game.owner_id == 1 and game.description.match(/goama/i)
      buf += 'Gra dostępna dzięki uprzejmości newslettera <a href="http://gogame.info">Goama</a>'
    elsif game.owner_id == 1 and game.description.match(/Dinerchtein/i)
      buf += 'Gra dostępna dzięki uprzejmości <a href="http://breakfast.go4go.net/">Alexandra Dinerchtein\'a</a>'
    elsif game.owner_id == 9 and game.description.match(/^Lee\sHajin/i)
      buf += 'Gra dostępna dzięki uprzejmości <a href="http://www.starbaduk.com/">Lee Hajin</a>'
    end
    buf.empty? ? '' : "<div class=\"ads\">#{buf}</div>"
  end
  
  def navigator game, prev_id, next_id
    buf = %(<div class="archive-navigator">)

    prev_link = '&lt;&lt;'
    next_link = '&gt;&gt;'
    
    if not prev_id.nil?
      prev_link = ( link_to prev_link, { :controller => 'games', :action => 'show', :id => prev_id }, { :title => 'Poprzednia gra z archiwum' } ) 
    end
    
    if not next_id.nil?
      next_link = (link_to next_link, { :controller => 'games', :action => 'show', :id => next_id }, { :title => 'Następna gra z archiwum' } )
    end
    
    buf += prev_link
    buf += '&nbsp;#'
    buf += (text_field_tag 'game_no', game.id, :size => 2, :onchange => "location.href='/games/show/'+this.value")
    buf += '&nbsp;'
    buf += next_link  
    buf += %(</div>)
#    buf += prev_id.to_s 
#    buf += ' X '
#    buf += next_id.to_s
    return buf
  end
  
end
