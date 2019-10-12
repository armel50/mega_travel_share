require "pry"
class PostController < ApplicationController

    get '/posts' do
        @notice =   flash[:notice] if   flash[:notice] 
        if Helper.logged_in?(session)
            @posts = Post.all  
            @user = Helper.current_user(session)
            erb :"post/index"
        else
            flash[:error] = "Please log in to view more content."
            redirect "/user/login"
        end
    end

    get '/posts/new' do 
        @error =  flash[:error] if  flash[:error]
        if Helper.logged_in?(session)
            erb :"post/new"
        else 
            flash[:error] = "Please log in to add a new post." 
            redirect 'user/login'
        end 
    end  

    post '/posts' do 
        if params[:title]=="" || params[:description]=="" 
            flash[:error] = "The title or the description can not be blank."
            redirect "/posts/new" 
        elsif params[:picture] == "" 
            
            if params[:file] == nil 
                flash[:error] = "please upload a picture or enter the url of a picture"
                redirect back
            else 
                
                @filename = Helper.upload(params)
                params[:picture]= "/#{@filename}"
            end
        end
            user = Helper.current_user(session)
            new_post= Post.create(title: params[:title], picture: params[:picture], description: params[:description])  
            user.posts << new_post

            redirect "/posts/#{new_post.id}"
        
    end 

    get '/posts/:id/edit' do 
        if Helper.logged_in?(session)
            @error = flash[:error] if flash[:error]
            @post = Post.find(params[:id])
            erb :"post/edit" 
        else 
            redirect "/user/login" 
        end
    end

    delete '/posts/:id' do
        post= Post.find(params[:id]) 
        if Helper.is_yours?(content: post, session: session)
            post.delete 
        end
        redirect back
    end

    patch '/posts/:id' do 
        post = Post.find(params[:id]) 
        if Helper.is_yours?(content: post, session: session)
            if params[:title] =="" || params[:description] =="" 
                flash[:error] = "Title, picture, and description can not be blank."
                redirect "/posts/#{params[:id]}/edit" 
            elsif  params[:picture] == "" 
                    if params[:file]== nil   
                        flash[:error] = "Please upload a picture or enter the url of a picture."
                        redirect back
                    else
                        @filename = Helper.upload(params)
                        params[:picture]= "/#{@filename}"
                    end
            end
                post.update(title: params[:title], description: params[:description], picture: params[:picture]) 
                redirect "/posts/#{post.id}"
        else
                edirect back
        end

    end

    get '/posts/:id' do
        @error =flash[:error]  if flash[:error]   
        @notice = flash[:notice] if flash[:notice]
        if Helper.logged_in?(session)
            @user = Helper.current_user(session)
            @post = Post.find(params[:id]) 
            erb :"post/show"
        else
            flash[:error] = "Please log in to continue."
            redirect "user/login"
        end
    end

     post "/posts/:id/like" do 
         if Helper.logged_in?(session)
            @user = Helper.current_user(session)
            @post = Post.find(params[:id])  
            new_like = Like.create(user_id: @user.id, post_id: @post.id) if !Like.find_by(post_id: @post.id, user_id: @user.id) 
            @post.likes << new_like if new_like
            @user.likes << new_like if new_like
            @post.likers << @user if !@post.likers.include?(@user)
            flash[:notice] = "You just liked #{@post.user.email}'s post." 
            redirect back
         else 
            flash[:error] = "You need to login to like a post."
            redirect "/user/login" 
         end
     end 

     delete '/posts/:id/like' do
        @post = Post.find(params[:id]) 
        @user = Helper.current_user(session) 
        like = Like.find_by(post_id: @post.id, user_id: @user.id) 
        like.delete if like
        flash[:notice] = "You just unliked #{@post.user.email}'s post." 
        redirect back
     end

end

