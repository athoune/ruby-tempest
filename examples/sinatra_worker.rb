require './sinatra_example'
require 'tempest'

ENV['RACK_ENV'] = 'test'

app = Sinatra::Application

tempest do

  worker :sinatra do
    on :url do |contexti, env|
      env = {
        "rack.version" => Rack::Version,
        #"rack.input"
        #"rack.errors"
        "rack.multithread" => false,
        "rack.multiprocess" => true,
        "rack.run_once" => false,
        "rack.url_scheme" => "http"
      }.merge(env)
      status, headers, body = app.call(env)
      context.answer status, headers, body
    end
  end.start_loop

end
