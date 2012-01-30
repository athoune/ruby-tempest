require './sinatra_example'
$:.unshift File.expand_path("../../lib", __FILE__)
require 'tempest'
require 'rack'
require 'stringio'

ENV['RACK_ENV'] = 'test'

app = Sinatra::Application

tempest do

  worker :sinatra do
    on :url do |context, env|
      input = StringIO.new
      input.set_encoding('ASCII-8BIT') if input.respond_to?(:set_encoding)
      input.rewind

      errors = StringIO.new
      errors.set_encoding('ASCII-8BIT') if input.respond_to?(:set_encoding)
      errors.rewind

      env = {
        "rack.version" => Rack::VERSION,
        "rack.input" => input,
        "rack.errors" => errors,
        "rack.multithread" => false,
        "rack.multiprocess" => true,
        "rack.run_once" => false,
        "rack.url_scheme" => "http",

        "REQUEST_METHOD" => env['method'],
        "PATH_INFO" => env['url'],
        "QUERY_STRING" => env['query'] || ''
      }.merge(env)
      status, headers, body = app.call(env)
      context.answer status, headers, body.join('')
    end
  end.start_loop

end
