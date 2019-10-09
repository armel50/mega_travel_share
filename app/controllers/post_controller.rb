class PostController < ApplicationController

    get '/posts' do
        @notice =   flash[:notice] if   flash[:notice] 
        if session[:user_id] 
            @posts = Post.all 
           
        else
         @posts = Post.all 
         @user = User.find(session[:user_id])
        end
        erb :"post/index"
    end

    get '/posts/new' do 
        if session[:user_id] 
            erb :"post/new"
      
        else  
            redirect 'user/login'
        end
        
    end  
    post '/posts' do 
        
        if params[:title]=="" || params[:picture]=="" || params[:description]=="" 
            redirect "/posts/new" 
        else
             user = User.find(session[:user_id]) 
            new_post= Post.create(title: params[:title], picture: params[:picture], description: params[:description])  
           
            user.posts << new_post

            redirect "/posts/#{new_post.id}"
        end
    end

    get '/posts/:id/delete' do 
        if session[:user_id] 
        
            redirect 'user/login'
        end
    end
    get '/posts/:id/edit' do 
        if session[:user_id]
            @error = flash[:error] if flash[:error]
            @post = Post.find(params[:id])
            erb :"post/edit" 
        else 
            redirect "/user/login" 
        end
    end

    delete '/posts/:id' do
        
        post= Post.find(params[:id]) 
        post.delete 
        redirect "/user/#{session[:user_id]}"
    end

    patch '/posts/:id' do 
        if params[:title] =="" || params[:description] =="" || params[:picture] == "" 
            flash[:error] = "Title, picture, and description can not be blank."
            redirect "/posts/#{params[:id]}/edit" 
        else 
            post = Post.find(params[:id])  
            post.update(title: params[:title], description: params[:description], picture: params[:picture]) 

            redirect "/posts/#{post.id}"
        end
        
    end

    get '/posts/:id' do
        @error =flash[:error]  if flash[:error]  
        if session[:user_id]
            @user = User.find(session[:user_id])
            @post = Post.find(params[:id]) 
        else
            @post = Post.find(params[:id]) 

        end
        erb :"post/show"
    end
end
