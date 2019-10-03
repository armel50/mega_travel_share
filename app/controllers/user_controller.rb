class UserController < ApplicationController 
    get '/user/signup' do
        erb :"user/sign_up"
    end 

    post '/user/signup' do
        if params[:email]!="" && params[:password]!=""
            new_user = User.create(email: params[:email] ,password: params[:password])
            session[:user_id] = new_user.id
            redirect "/user/#{new_user.id}"
        else
            redirect '/user/signup'
        end
        
    end 

    get '/user/login' do 
        erb :"user/log_in"
    end 

    post '/user/login'  do 
        @user = User.find_by(email: params[:email]) 
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            redirect "/user/#{@user.id}"
            else 
                redirect '/user/login'
        end  

        

        
    end


    get '/user/logout' do
        p session
        session.clear
        redirect '/user/login'
    end

    get '/user/:id' do 
        if session[:user_id] 
            @user = User.find(session[:user_id]) 
            erb :"user/profile"

        else
            redirect 'user/login'
        end
        
    end 

  
end