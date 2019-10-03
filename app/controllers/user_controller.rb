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
                    flash[:error] = "This email is already being used."
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

    get '/user/:id' do 
        if session[:user_id] 
            @notice = flash[:notice] if flash[:notice]
            @user = User.find(session[:user_id]) 
            erb :"user/profile" 

        else
            redirect 'user/login'
        end
        
    end 

  
end