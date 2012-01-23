require "tempest/cluster"

class Tempest_bloc
  attr_reader :cluster

  def initialize &block
    @cluster = Tempest::Cluster.new
    instance_eval &block
  end

  def worker queue, &block
    w = Worker.new @cluster, queue, &block
    w.loop
    w
  end

end

def tempest &block
  Tempest_bloc.new &block
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

  def loop
    @cluster.loop
  end

  def stop_loop
    @cluster.loop = false
  end
end

