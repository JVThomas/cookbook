class CommentsController < ApplicationController
  before_action :params_check, only:[:create]
  before_action :set_user, only:[:index, :show]
  before_action :set_comment, only:[:edit, :show, :destroy, :update]
  
  def create
    @comment = Comment.new(comment_params)
    comment_save(:new)
  end

  def index
    @comments = @user.comments
  end

  def edit
    @authorize(@comment)
  end

  def update
    @authorize(@comment)
    comment_save(:edit)
  end

  def show
    if params[:user_id].to_i != @comment.user.id
      flash[:alert] = "Comment does not belong to specified user"
      home_redirect
    end
  end

  def destroy
    @authorize(@comment)
    @comment.destroy

  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :recipe_id)
    end

    def comment_save
      if @comment.valid?
        @comment.save
        flash[:notice] = "Comment successfully saved"
      else
        flash[:alert] = "Comment must be filled in"  
      end
      redirect_to recipe_path(@comment.recipe)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

end
