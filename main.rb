require 'sinatra/base'
require 'sass'
require 'slim'
require 'sinatra/flash'
require 'pony'
require './sinatra/auth'
require 'v8'
require 'coffee-script'
# Website songs by sinatra
class Website < Sinatra::Base
  register Sinatra::Auth
  register Sinatra::Flash

  configure do
    enable :sessions
    set :username, 'frank'
    set :password, 'sinatra'
  end

  get('/styles.css') { scss :styles }
  get('/javascripts/application.js') { coffee :application }

  before do
    set_title
  end

  helpers do
    def css(*stylesheets)
      stylesheets.map do |stylesheet|
        "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
      end.join
    end

    def current?(path="/")
      (request.path==path || request.path==path+'/') ? "current" : nil
    end

    def set_title
     @title ||= "Songs By Sinatra"
    end

    def send_message
      Pony.mail(
        :from => params[:name] + "<" + params[:email] + ">",
        :to => 'robbpando@gamil.com',
        :subject => params[:name] + "has contacted you",
        :body => params[:message],
        :port => '587',
        :via => :smtp,
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'rob',
          :password             => 'secrete',
          :authentication       => :plain,
          :domain               => 'localhost.localdomain'
          })
    end
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

  post '/contact' do
    send_message
    flash[:notice] = "Thank you for your message. We'll be in touch soon."
    redirect to '/'
  end

  not_found do
    @title = "Page Not Found"
    slim :not_found
  end
end
