class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :find_commentable
  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = @commentable
    if @comment.save
      redirect_to @commentable, notice: "Comment created"
    else
      folder_name = @commentable.class.to_s.underscore.pluralize
      render "/#{folder_name}/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end


  def find_commentable
    if params[:campaign_id]
      @campaign = @commentable = Campaign.friendly.find params[:campaign_id]
    end
  end
end
