class IssueCommentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  
  def pre_load
    @issue = Issue.find(params[:issue_id]) if params[:issue_id]
    @comment = Comment.find(params[:id]) if params[:id]
  end
  
  def create
    @comment = @issue.comments.build(:content => params[:comment])
    @comment.creator = current_user
    @comment.save

    render :layout => false
  end
  
  
  def reply
    @issue = @comment.model
    reply_comment = @issue.comments.build(:content => params[:comment])
    reply_comment.reply_comment_id = @comment.id
    reply_comment.creator = current_user
    reply_comment.save

    render :layout => false
  end


  def destroy
    @comment.destroy
    render :nothing => true
  end

end
