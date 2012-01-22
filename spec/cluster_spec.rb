require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest"

  class DummyCluster < Tempest::Cluster
    attr_reader :test

    def foo args, who, job_id
      @test = true
      @loop = false
      #answer who, :foo, job_id, ['Hello #{args[0]}']
    end

  end

describe Tempest::Cluster do

  let :cluster do
    DummyCluster.new
  end

  it "should connect and fetch some works to do" do
    cluster.work 'working', :foo, ['bar'], nil
    cluster.loop
    cluster.test.should be_true
  end

end
