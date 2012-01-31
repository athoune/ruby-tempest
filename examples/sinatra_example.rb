require 'sinatra'

get '/' do
  "Hello world from #{params[:name]}\n"
end

post '/' do
  x = JSON.parse request.body.read
  "Hello posted from #{x['user']}\n"
end
