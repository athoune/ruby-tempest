require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest"

describe Tempest::Cluster do

  it "should connect and fetch some works to do" do
    $msg = nil

    tempest do
      worker :working do

        on :foo do |context, name|
          $msg = name
          context.stop
        end

        work :foo, nil, 'bar'

      end.start_loop
    end

    $msg.should == 'bar'

  end
end
