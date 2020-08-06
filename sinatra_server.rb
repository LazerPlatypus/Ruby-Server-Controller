require 'sinatra'
require_relative 'scripts/user_management'
require_relative 'scripts/text_processing'
AppLoc = File.dirname(__FILE__)
set :root, File.join(AppLoc, 'resources')
enable :sessions

helpers do
    def login?
        if session[:username].nil?
            return false
        else
            return true
        end
    end

    def username
        return session[:username]
    end

    @user_manager = UserManagement.new
end

get '/' do
    redirect '/index'
end

get '/index' do
    @filenames = get_story_names()
    @filenames
    erb :index, layout: :'index_layout'
end

post '/index' do
    @text = load_story(@params.values[0])
    @text
    erb :read_post, layout: :'read_post_layout'
end

get '/post' do
    if login?()
        erb :make_post, layout: :'make_post_layout'
    end
end

post '/make_post' do
    save_story(@params.values[0], @params.values[1])
    redirect '/index'
end

get '/login' do
    erb :login
end

post '/login' do
    puts params[:username]
    puts params[:password]
    # if @user_manager.login(params[:username], params[:password])
        session[:username] = params[:username]
        redirect '/post'
    # else
        puts "failure"
        redirect '/index'
    # end
end

get '/logout' do
    session[:username] = nil
    redirect '/index'
end