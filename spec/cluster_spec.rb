require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest"

describe Tempest::Cluster do

  it "should connect and fetch some works to do" do
    msg = []
    n = 100

    # With the default cluster
    tempest do
      #on a queue named working
      worker :working do

        # on a foo event, with a context an name as arguments
        on :foo do |context, name|
          msg << name
          n -= 1
          context.stop if n == 0 # stop the event loop
        end

        # action: :foo
        # respond_to: nil
        # arguments: ['bar']
        100.times do
          work :foo, nil, 'bar'
        end

      end.start_loop # start the event loop
    end

    msg.length.should == 100
    msg[50].should == 'bar'

  end
end
