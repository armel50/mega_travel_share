class UserController < ApplicationController 

 
    get '/user/signup' do
        @error =flash[:error]  if flash[:error]
        erb :"user/sign_up"
    end 

    post '/user/signup' do
        if params[:email]!="" && params[:password]!=""

            if !User.find_by(email:params[:email] )
                new_user = User.create(email: params[:email] ,password: params[:password]) 
                session[:user_id] = new_user.id  
                flash[:notice] = "You are successfully Signed Up."
                redirect "/user/#{new_user.id}"
                else 
                    flash[:error] = "This email is already in use."
                    redirect '/user/signup' 
            end
            
        else
            flash[:error] ="Email or password can not be blank." 
            redirect '/user/signup'
        end
        
    end 

    get '/user/login' do 
        @error =flash[:error]  if flash[:error]
        erb :"user/log_in"
    end 

    post '/user/login'  do 
        @user = User.find_by(email: params[:email]) 
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            flash[:notice] = "You are successfully Signed In."
            redirect "/user/#{@user.id}"
            else 
                flash[:error]= "The email or password was wrong."
                redirect '/user/login'
        end  

        

        
    end


    get '/user/logout' do
        p session
        session.clear
        redirect '/user/login'
    end


    get '/user/friends' do 
        if session[:user_id]  
            user = User.find(session[:user_id]) 
            @friends = user.friends
        
            erb :"user/friends" 
        else 
            flash[:error] = "You need to log in to see your friends"
            redirect '/user/login'
        end
        
    end

    get '/user/:user_id/followings' do 
        if session[:user_id] 
            @notice =  flash[:notice] if flash[:notice]
            @user = User.find(params[:user_id]) 
            erb :"user/followings"
        else 
            flash[:error] = "You need to sign in to view the people you follow."
            redirect "/user/login"
        end
    end 

    get '/user/:user_id/followers' do 
        if session[:user_id]
            @notice =  flash[:notice] if flash[:notice]

            @user = User.find(params[:user_id])
            erb :"user/followers"
        else 
            flash[:error] = "You need to sign in to view your followers."  
            redirect "/user/login"
        end
    end

    get '/user/:id' do 
       
            @notice = flash[:notice] if flash[:notice]
            @user = User.find(params[:id]) 
            @checker = User.find(session[:user_id])
            erb :"user/profile" 
                  
    end 
end