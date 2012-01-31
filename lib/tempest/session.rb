require 'redis'
require 'json'

module Tempest
  # FIXME handling timeout
  class Session

    def initialize redis, id, prefix="session:"
      @redis = redis
      @id = "#{prefix}#{id}"
    end

    def store key, value
      @redis.hset @id, key, [value].to_json
    end

    alias :[]= :store

    def fetch key, default=nil
      r = @redis.hget(@id, key)
      return default if r.nil?
      JSON.parse(r)[0]
    end

    alias :[] fetch

    def delete key
      @redis.hdel @id, key
    end

    def clear
      @redis.del @id
    end

  end
end
