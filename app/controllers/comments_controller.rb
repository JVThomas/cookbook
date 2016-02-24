class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(comment_params)
    comment_save(@comment)
    redirect_to recipe_path(@comment.recipe)
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :recipe_id)
    end

    def comment_save(comment)
      if comment.save
        flash[:notice] = "Comment successfully saved"
      else
        flash[:notice] = "Comment did not save successfully"
      end
    end

end
