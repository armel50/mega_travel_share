class CommentController < ApplicationController
    # get '/posts/:id/comments' do 
       
    #     erb :"post/show"
    # end

    post "/posts/:id/comments" do 
        
        if params[:comment][:content] == "" 
            flash[:error] = "You can not have a empty comment" 
    
            redirect "/posts/#{params[:id]}"
        else
            if session[:user_id] 
                user = User.find(session[:user_id]) 
                post = Post.find(params[:id])
                new_comment = Comment.create(content: params[:comment][:content])  
                user.comments << new_comment  
                post.comments << new_comment
                p new_comment
                
                redirect "/posts/#{params[:id]}"
            else 
                flash[:error]= "You need to login to add a comment"
                redirect "/user/login"  

            end
        end
        
    end

    delete "/posts/:post_id/comments/:id" do  
      comment = Comment.find( params[:id])  
      comment.delete 
      redirect "/posts/#{params[:post_id]}"
    end

end