class CommentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  
  def pre_load
    @story = Story.find(params[:story_id]) if params[:story_id]
    @comment = Comment.find(params[:id]) if params[:id]
  end
  
  def create
    @comment = @story.comments.build(params[:comment])
    @comment.creator = current_user
    if !@comment.save
      error = @comment.errors.first
      flash[:error] = "#{error[0]} #{error[1]}"
    end
    redirect_to "/stories/#{@story.id}"
  end
  
  def reply
  end
  
  def do_reply
    story = @comment.model
    reply_comment = story.comments.build(params[:comment])
    reply_comment.reply_comment_id = @comment.id
    reply_comment.creator = current_user
    if reply_comment.save
      return redirect_to "/stories/#{story.id}"
    end
    error = reply_comment.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/stories/#{story.id}"
  end
end
