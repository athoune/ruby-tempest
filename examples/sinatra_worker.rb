require './sinatra_example'
$:.unshift File.expand_path("../../lib", __FILE__)
require 'tempest'
require 'rack'
require 'stringio'

ENV['RACK_ENV'] = 'test'

app = Sinatra::Application

tempest do

  worker :sinatra do
    input = StringIO.new
    input.set_encoding('ASCII-8BIT') if input.respond_to?(:set_encoding)
    errors = StringIO.new
    errors.set_encoding('ASCII-8BIT') if errors.respond_to?(:set_encoding)

    on :url do |context, env|
      input.rewind
      input.write env['body'] if env['body']

      errors.rewind

      path_info, query_string = env['url'].split('?')
      env = {
        "rack.version" => Rack::VERSION,
        "rack.input" => input,
        "rack.errors" => errors,
        "rack.multithread" => false,
        "rack.multiprocess" => true,
        "rack.run_once" => false,
        "rack.url_scheme" => "http",

        "REQUEST_METHOD" => env['method'],
        "PATH_INFO" => path_info,
        "QUERY_STRING" => query_string || ''
      }.merge(env)
      status, headers, body = app.call(env)
      context.answer status, headers, body.join('')
    end
  end.start_loop

end
