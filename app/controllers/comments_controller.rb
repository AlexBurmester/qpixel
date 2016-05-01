# Provides mainly web actions for using and making comments.
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, :only => [:update, :destroy, :undelete]

  # Authenticated web action. Creates a comment based on the data passed.
  def create
    @comment = Comment.new comment_params
    post = params[:post_type] == 'Question' ? Question.find(params[:post_id]) : Answer.find(params[:post_id])
    @comment.post = post
    @comment.user = current_user
    if @comment.save
      if params[:post_type] == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => post.question.id)
      end
    else
      flash[:error] = "Comment failed to save."
      if params[:post_type] == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => post.question.id)
      end
    end
  end

  # Authenticated web action. Updates an existing comment with new data, based on the parameters passed to the request.
  def update
    if @comment.update comment_params
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    else
      flash[:error] = "Comment failed to update."
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    end
  end

  # Authenticated web action. Deletes a comment by setting the <tt>is_deleted</tt> field to true.
  def destroy
    @comment.is_deleted = true
    if @comment.save
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    else
      flash[:error] = "Comment marked deleted, but not saved - status unknown."
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    end
  end

  # Authenticated web action. Undeletes a comment by returning the <tt>is_deleted</tt> field to false.
  def undelete
    @comment.is_deleted = false
    if @comment.save
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    else
      flash[:error] = "Comment marked undeleted, but not saved - status unknown."
      if @comment.post_type == 'Question'
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.id)
      else
        redirect_to url_for(:controller => :questions, :action => :show, :id => @comment.post.question.id)
      end
    end
  end

  private
    # Sanitizes parameters for use in creating or updating comments.
    def comment_params
      params.require(:comment).permit(:content)
    end

    # Finds the comment with the given ID and sets it to the <tt>@comment</tt> variable.
    def set_comment
      @comment = Comment.find params[:id]
    end
end
