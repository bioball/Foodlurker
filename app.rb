require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'time'

set :database, "sqlite3:///foodlurker.db"

class Location < ActiveRecord::Base
  has_many :events
end

class Event < ActiveRecord::Base
  belongs_to :location
end

use Rack::MethodOverride

get "/" do
  @locations = Location.all
  erb :index
end

get "/:location" do
  @location = Location.find(params[:location])
  @events = @location.events
  erb :listing
end

get "/:location/new" do
  @location = Location.find(params[:location])
  @event = @location.events.new
  @today = Time.now
  erb :newevent
end

post "/:location/new" do
  @location = Location.find(params[:location])
  params[:event][:starttime] = dateparser(params[:event][:starttime])
  @event = @location.events.new(params[:event])
  if @event.save
    redirect "/#{@event.location.id}"
  else
    erb :newevent
  end
end

delete "/:location/:event" do
  @event = Event.find(params[:event])
  @event.destroy
  redirect "/#{@event.location.id}"
end

helpers do

  def dateparser(date)
    Time.parse(date)
  end

end