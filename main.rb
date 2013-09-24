require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite:///development.sqlite3"

get "/" do
  erb :index
end

__END__