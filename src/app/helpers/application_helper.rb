# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  include TagsHelper

  def user?
    !session[:user].nil?
  end

  def owner? game
    user? and session[:user].id == game.owner_id
  end

def cut(text, length = 100, truncate_string = "...")
  if text
    l = length - truncate_string.chars.to_a.length
    chars = text.chars
    (chars.to_a.length > length ? chars.to_a[0...l].to_s + truncate_string : text).to_s
  end
end

#  def cut comment, length = 100, suffix = "..."
#    #cut = comment.chars.slice(0, length)
#    cut = comment
#    cut.size == length ? cut + suffix : comment
#  end

  def loading_indicator div_id
    "<div id=\"#{div_id}\" style=\"display: none; float: right;\">#{image_tag 'ajax-loader.gif'}</div>"
  end

  def odd_or_even index
    (index % 2 == 0) ? 'even' : 'odd'
  end

  # links {{{
  def link_to_profile user_login
    link_to user_login, :controller => 'profile', :action => user_login
  end

  def link_to_profile_with_label label, user_login
    link_to label, :controller => 'profile', :action => user_login
  end

  def link_to_user_games user_login, description
    link_to description, :controller => 'games', :action => 'added_by', :id => user_login
  end
  
#  def sexy_button_link text, link
#    "<a class=\"button\" href=\"#{link}\"><span>#{text}</span></a>"
#  end
  
#  def sexy_button_link_to_function text, function
#    "<a class=\"button\" href=\"#\" onclick=\"#{function}\"><span>#{text}</span></a>"
#  end
  # }}}
  # date/time formatting {{{
  def fmt_date date
    date.strftime('%d/%m/%Y')
  end

  def fmt_time time
    time.strftime('%H:%M')
  end

  def fmt_datetime datetime
    "#{fmt_date datetime}, #{fmt_time datetime}"
  end

  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? 'mniej niż minutę temu' : '1 min.' unless include_seconds
        case distance_in_seconds
          when 0..4   then '5 sek. temu'
          when 5..9   then '10 sek. temu'
          when 10..19 then '20 sek. temu'
          when 20..39 then 'pól minuty temu'
          when 40..59 then 'minutę temu'
          else             '1 min.'
        end
      when 2..44           then "#{distance_in_minutes} min. temu"
      when 45..89          then 'około 1h temu'
      when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} godz. temu"
      when 1440..2879      then 'wczoraj'
      when 2880..43199     then "#{(distance_in_minutes / 1440).round} dni temu"
      when 43200..86399    then 'miesiąc temu'
      when 86400..525959   then "#{(distance_in_minutes / 43200).round} miesięcy temu"
      when 525960..1051919 then 'rok temu'
      else                      "ponad #{(distance_in_minutes / 525960).round} lata temu"
    end
  end
  # }}}
  # form helpers {{{
  protected
    def wrap_with_label_and_errors object, field, text, tag_to_wrap
      error_tag =  (error_message_on object, field)
      css_class = (error_tag.empty? ? 'field' : 'fieldWithErrors')
      "<div class=\"#{css_class}\">#{(label_for object, field, :text => text) + tag_to_wrap + error_tag}</div>"
    end

  public
#    def sexy_button text, form_name, tabindex = 1
#      "<a class=\"button\" onclick=\"this.blur();if(document.#{form_name}.onsubmit()){document.#{form_name}.submit();};\" tabindex=\"#{tabindex}\"><span>#{text}</span></a>"
#    end
    
    
    def form_plain_input name, text, size, tabindex, type = "text"
      label_tag(name, text) + text_field_tag(name, nil, :size => size, :tabindex => tabindex)
    end

    def form_plain_textarea name, text, cols, rows, tabindex
      label_tag(name, text) + text_area_tag(name, nil, :size => "#{cols}x#{rows}", :tabindex => tabindex)
    end

    def form_select object, field, text, tabindex, collection, selected_value = '', value_method = :to_s, text_method = :to_s
      wrap_with_label_and_errors object, field, text, 
        (collection_select object, field, collection, value_method, text_method, { :selected_value => selected_value }, { :tabindex => tabindex })
    end

    def form_input object, field, text, size, tabindex, type = "text"
      wrap_with_label_and_errors object, field, text, 
        (text_field object, field, :size => size, :tabindex => tabindex, :type => type)
    end

    def form_password object, field, text, size, tabindex, type = "password"
      wrap_with_label_and_errors object, field, text, 
        (password_field object, field, :size => size, :tabindex => tabindex, :type => type)
    end

    def form_file object, field, text, size, tabindex, type = "file"
      wrap_with_label_and_errors object, field, text,
        (file_field object, field, :size => size, :tabindex => tabindex, :type => type)
    end

    def form_textarea object, field, text, cols, rows, tabindex
      wrap_with_label_and_errors object, field, text, 
        (text_area object, field, :cols => cols, :rows => rows, :tabindex => tabindex)
    end

    def form_autocomplete_textarea object, field, text, tabindex
      wrap_with_label_and_errors object, field, text,
       (text_field_with_auto_complete object, field, { :tabindex => tabindex }, { :tokens => ',', :min_chars => 2 } )
    end

    def my_in_place_editor object, method, external_control = ''
      in_place_editor_field object, method, {}, { :rows => 3, :click_to_edit_text => 'Kliknij, aby wyedytować', :save_text => 'Zapisz!', :cancel_text => 'Anuluj', :loading_text => 'Ładowanie...', :saving_text => 'Zapisywanie...', :external_control => external_control }
    end

  # }}}
  # sgf regexp helpers {{{
  def sgf_white_player game
    matched_or_empty(/PW\[([\w*\s*\.]+)\]/, game.sgf)
  end

  def sgf_white_rank game
    matched_or_empty(/WR\[([\w*\s*\.,]+)\]/, game.sgf)
  end 
  
  def sgf_black_player game
    matched_or_empty(/PB\[([\w*\s*\.]+)\]/, game.sgf)
  end 

  def sgf_black_rank game
    matched_or_empty(/BR\[([\w*\s*\.,]+)\]/, game.sgf)
  end 

  def sgf_board_size game
    matched_or_empty(/SZ\[((\w*\s*)+)\]/, game.sgf)
  end

  def sgf_result game
    matched_or_empty(/RE\[(.*?)\]/, game.sgf)
  end 
  
  def sgf_komi game
    matched_or_empty(/KM\[(.*?)\]/, game.sgf)
  end

  def sgf_handicap game
    matched_or_empty(/HA\[(\d*)\]/, game.sgf)
  end 

  def white_player_with_rank game
    "#{sgf_white_player game} (#{sgf_white_rank game})"
  end
  
  def black_player_with_rank game
    "#{sgf_black_player game} (#{sgf_black_rank game})"
  end
  
  def board_size game
    board = sgf_board_size game
    if board == "?"
      board
    else
      "#{board}x#{board}"
    end
  end

  def game_details game
    handicap = sgf_handicap game
    if not handicap.eql? "?"
      handicap = ", Handicap: #{handicap}"
    else
      handicap = ""
    end
    h("#{board_size game}, #{white_player_with_rank game} vs #{black_player_with_rank game}#{handicap}, ") + "#{sgf_result_with_icons game}"
  end

  def short_game_details game
    "#{white_player_with_rank game} vs #{black_player_with_rank game}"
  end
  
  def sgf_result_with_icons game
    result = sgf_result game
    return result if result.eql? '?' 
    result = result.split('+').each { |x| x.strip! }
    "<span class=\"game_result\">#{stone_icon(result[0])}+#{result(result[1])}</span>"
  end
  
  # }}}

  protected
    def matched_or_empty regexp, value
      match = regexp.match(value)
      match.nil? ? '?' : match[1]
    end

    def stone_icon stone
      return '<img src="/player/images/w.png" alt="Biały"/>' if stone.match(/[wW]/)
      return '<img src="/player/images/b.png" alt="Czarny"/>' if stone.match(/[bB]/)
      return ''
    end

    def result result
      return '?' if result.nil?
      return result if result.match(/\d+\.?\d*/)
      return 'T' if result.match(/[Tt].*/)
      return 'R' if result.match(/\w+/)
      return '?'
    end
    
end
