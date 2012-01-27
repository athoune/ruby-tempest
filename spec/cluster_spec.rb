require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest"

describe Tempest::Cluster do

  it "should connect and fetch some works to do" do
    $msg = nil

    # With the default cluster
    tempest do
      #on a queue named working
      worker :working do

        # on a foo event, with a context an name as arguments
        on :foo do |context, name|
          $msg = name
          context.stop # stop the event loop
        end

        # action: :foo
        # respond_to: nil
        # arguments: ['bar']
        work :foo, nil, 'bar'

      end.start_loop # start the event loop
    end

    $msg.should == 'bar'

  end
end
