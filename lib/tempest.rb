require "tempest/cluster"

class Tempest_bloc
  attr_reader :cluster

  def initialize redis, &block
    @cluster = Tempest::Cluster.new redis
    instance_eval &block
  end

  def worker queue, &block
    Worker.new @cluster, queue, &block
  end

end

def tempest redis='localhost:6379', &block
  Tempest_bloc.new redis, &block
end

class Worker
  attr_reader :queue, :cluster
  def initialize cluster, queue, &block
    @cluster = cluster
    @queue = queue
    instance_eval &block
  end

  def on action, &block
    @cluster.on action, &block
  end

  def work action, respond_to, *args
    @cluster.work @queue, action, *args, respond_to
  end

  def start_loop
    @cluster.loop
  end

  def stop_loop
    @cluster.loop = false
  end
end

