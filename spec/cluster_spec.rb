require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest"


describe Tempest::Cluster do

  it "should connect and fetch some works to do" do
    @@done = false
    tempest do
      worker :working do
        on :foo do |context, name|
          p "#{name} was here"
          @@done = true
          context.stop
        end

        work :foo, nil, 'bar'
      end
    end

    @@done.should be_true

  end
end
