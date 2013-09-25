require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:///foodlurker.db"

class Location < ActiveRecord::Base
  has_many :events
end

class Event < ActiveRecord::Base
  belongs_to :location
end

get "/" do
  @locations = Location.all
  erb :index
end

get "/:location" do
  @events = Event.find(:all, conditions: )
  erb :listing
end