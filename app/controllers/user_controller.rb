class UserController < ApplicationController 

    get '/user/signup' do
        @error =flash[:error]  if flash[:error]
        if !Helper.logged_in?(session)
            @current_path = request.path_info 
            @action = @current_path.gsub("/user/","")
            erb :"user/log_in_or_sign_up"
        else
            redirect "/posts"
        end
    end 

    post '/user/signup' do
        if params[:email]!="" && params[:password]!=""

            if !User.find_by(email:params[:email] )
                new_user = User.create(email: params[:email] ,password: params[:password]) 
                session[:user_id] = new_user.id  
                flash[:notice] = "Welcome for the first time #{new_user.email}."
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
        if !Helper.logged_in?(session)
            @current_path = request.path_info 
            @action = @current_path.gsub("/user/","")
            erb :"user/log_in_or_sign_up"
        else
            redirect "/posts"
        end
    end 

    post '/user/login'  do 
        @user = User.find_by(email: params[:email]) 
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            flash[:notice] = "Welcome back #{@user.email}."
            redirect "/user/#{@user.id}"
            else 
                flash[:error]= "The email or password was wrong."
                redirect '/user/login'
        end  
        
    end


    get '/user/logout' do
        session.clear
        redirect '/user/login'
    end

    get '/user/:user_id/followings' do 
        if Helper.logged_in?(session)
            @notice =  flash[:notice] if flash[:notice]
            @user = User.find(params[:user_id]) 
            erb :"user/followings"
        else 
            flash[:error] = "You need to sign in to view the people you follow."
            redirect "/user/login"
        end
    end 

    get '/user/:user_id/followers' do 
        @notice =  flash[:notice] if flash[:notice]
        @user = User.find(params[:user_id])
        if Helper.logged_in?(session)
            erb :"user/followers"
        else 
            flash[:error] = "You need to sign in to view your followers."  
            redirect "/user/login"
        end
    end

    get '/user/:id' do 
            @notice = flash[:notice] if flash[:notice] 
            if Helper.logged_in?(session)
                @user = User.find(params[:id]) 
                @current_user = Helper.current_user(session)
                erb :"user/profile"   
            else
                flash[:error] = "Please log in to view a profile page"
                redirect "user/login"     
            end
    end 
end