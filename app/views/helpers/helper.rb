class Helper 
    def self.logged_in?(session)
        true if session[:user_id]
    end

    def self.current_user(session)
        @user = User.find(session[:user_id]) if self.logged_in?(session)
    end

    def self.upload(params) 
        @filename = params[:file][:filename]
        file = params[:file][:tempfile]
        File.open("./public/#{@filename}", 'wb') do |f|
           f.write(file.read)
        end 
        @filename
    end

    def self.is_yours?(content:,session:) 
        true if content.user = self.current_user(session)
    end

end