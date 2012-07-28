module CommentHelper

  def do_clear_comment_tip_message!
    if logged_in?
      current_user.comment_tip_message.clear
      current_user.comment_tip_message.send_count_to_juggernaut
    end
  end

end