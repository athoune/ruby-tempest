require 'json'
require 'redis'

REDIS = 'localhost:6379'

module Tempest

  class Context
    attr_reader :respond_to, :job_id
    def initialize cluster, respond_to, job_id
      @respond_to = respond_to
      @job_id = job_id
      @cluster = cluster
    end

    def stop
      @cluster.loop = false
    end
  end

  class Cluster

    attr_accessor :loop
    def initialize
      @_client = {}
      @_on = {}
      @loop = true
      @id = 0
    end

    def client server
      unless @_client.key? server
        hp = server.split(':')
        @_client[server] = Redis.new host: hp[0], port: hp[1].to_i
      end
      @_client[server]
    end

    def on action, &block
      @_on[action] = block
    end


    def loop
      @loop = true
      while @loop
        task = client(REDIS).blpop 'working', 0
        if task
          cmd, args, answer, job_id = JSON.parse(task[1])
          @_on[cmd.to_sym].call Context.new(self, answer, job_id), *args
        end
      end
    end

    def answer who, action, job_id, args
      client(who).send action, job_id, args.to_json
    end

    def work queue, action, args, respond_to
      #FIXME implement the real id tactic
      @id += 1
      client(REDIS).rpush queue, [action, args, respond_to, @id].to_json
      @id
    end

  end

end
