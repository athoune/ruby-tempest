require 'sinatra'

get '/' do
  "Hello world from #{params[:name]}\n"
end
