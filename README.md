Ruby tempest
============

Ruby client for joining a [tempest cluster](https://github.com/athoune/node-tempest).

With this gem, you can build a worker in plain old sequential ruby with a simple DSL, using your favorite gems.

Test
----

Launch a redis server:

    redis-server

Lauch the tests:

    rspec

Code
----

The foreman:

```ruby
require 'tempest'

tempest do
  worker :working do #The working queue
    work :foo, nil, 'World' #nil is for 'no response needed'
  end
end
```

The worker :

```ruby
require 'tempest'

tempest do
  worker :working do
    on :foo do |context, name|
      p "hello #{name}"
      context.stop # stop the event loop
    end
  end.start_loop #start the event loop
end
```

The queue is handled by Redis, you can start many workers, after or before the foreman, it doesn't care.

Status
------

Alpha.

Tempestas
---------

The tempest gem already exists, not _tempestas_. Latin ruled the world.

Licence
-------

MIT
