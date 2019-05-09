module RssHelper
  def game_long_desc game
    game.description # TODO (use SGF helper methods)
  end

  def comment_long_desc comment
    comment.comment # TODO: more more!
  end
end
