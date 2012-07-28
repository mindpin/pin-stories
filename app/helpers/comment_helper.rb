module CommentHelper

  def do_clear_comment_tip_message!
    if logged_in?
      current_user.comment_tip_message.clear
      current_user.comment_tip_message.send_count_to_juggernaut
    end
  end

  def comment_from_content(comment)
    model = comment.model

    case model
    when Story
      return truncate_u model.how_to_demo, 16
    when Issue
      return truncate_u model.content, 16
    end
  end

end