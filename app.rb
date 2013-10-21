require 'rubygems'
require 'compass'
require 'sinatra'
require 'sinatra/activerecord'
require 'time'
require 'geocoder'
require 'sinatra/flash'

class Foodlurker < Sinatra::Application
  set :scss, {style: :compact, debug_info: :false}
  set :database, "sqlite3:///foodlurker.db"
  enable :sessions

  configure do
    Compass.add_project_configuration(File.join(Sinatra::Application.root, 
      'config', 'compass.rb'))
  end

  configure :production do
    set :clean_trace, true
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

#initiate models
require_relative 'models/init'

get "/stylesheets/:name.css" do
  content_type 'text/css', charset: 'utf-8'
  scss(:"stylesheets/sass/#{params[:name]}")
end

get "/" do
  erb :main
end

get "/events/new" do
  @event = Event.new
  @today = Time.now
  erb :"events/new"
end

post "/events/new" do
  if Geocoder.search(params[:event][:address]) == []
    flash[:warning] = "Address not recognized"
    erb :"events/new"
  else
    params[:event][:starttime] = Time.parse(params[:event][:starttime])
    params[:event][:endtime] = Time.parse(params[:event][:endtime])
    params[:event][:latitude] = Geocoder.search(params[:event][:address])[0].geometry["location"]["lat"]
    params[:event][:longitude] = Geocoder.search(params[:event][:address])[0].geometry["location"]["lng"]
    params[:event][:address] = Geocoder.search(params[:event][:address])[0].formatted_address
    @event = Event.new(params[:event])
    if @event.save
      @flash.now[:success] = "Event created!"
      redirect "/events/#{@event.id}"
    end
  end
end

get "/events/all" do
  @events = Event.all
  erb :"events/index"
end

get "/events/:id" do
  @event = Event.find(params[:id])
  erb :"events/listing"
end

delete "/events/:id" do
  @event = Event.find(params[:id])
  @event.destroy
  redirect "/"
end