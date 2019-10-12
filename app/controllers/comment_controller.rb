class CommentController < ApplicationController
    post "/posts/:id/comments" do 
        if params[:comment][:content] == "" 
            flash[:error] = "You can not have a empty comment" 
            redirect "/posts/#{params[:id]}"
        else
            user = Helper.current_user(session) 
            post = Post.find(params[:id])
            new_comment = Comment.create(content: params[:comment][:content])  
            user.comments << new_comment  
            post.comments << new_comment
            redirect "/posts/#{params[:id]}"   
        end 
    end

    delete "/posts/:post_id/comments/:id" do  
        comment = Comment.find(params[:id]) 
        if Helper.is_yours?(content: comment, session: session) 
            comment.delete 
            redirect back
        else 
            redirect back
        end
    end  

end