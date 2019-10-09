class FollowingController < ApplicationController
    post '/follow/:user_id' do 
         if session[:user_id] 
            user = User.find(session[:user_id]) 
            friend = User.find(params[:user_id])   
            friend.followers << user if !friend.followers.include?(user) 
            user.followings << friend if !user.followings.include?(friend)

            
            flash[:notice] ="You are now following #{friend.email}!"
            redirect back

         else 
            flash[:error] = "You need to be signed in to follow someone."
            redirect '/user/login'
         end
    end
end