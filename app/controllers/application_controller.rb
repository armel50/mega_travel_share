require './config/environment'
require 'pry'
require 'sinatra/flash'
class ApplicationController < Sinatra::Base
  register Sinatra::Flash
  configure do
    set :public_folder, 'public'
    set :views, 'app/views' 
    enable :sessions
    set :session_secret, "jemangedufoutou"
  
  end

  get "/" do
    erb :welcome
  end

end
