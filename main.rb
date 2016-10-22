require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'slim'
require './song'

set :public_folder, '/assets'
get('/styles.css'){ scss :styles }

configure do
	enable :sessions
	set :username, 'frank'
	set :password, 'sinatra'
end

configure :development do 
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do 
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/' do 
	slim :home
end

get '/about' do
	@title = "All About This Website"
	slim :about
end

get '/contact' do
	@title = "Contact Us"
	slim :contact
end

get '/login' do
	slim :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/songs')
	else
		@invalid_message = true
		slim :login
	end
end

get '/logout' do
	session.clear
	redirect to('/login')
end

not_found do
	@title = "Page Not Found"
	slim :not_found
end







