Tempest as a Rack server
========================

Dependencies
------------

    npm install tempest redis connect hiredis

Try it
------

Lauch the front:

    node front.js

One or more workers:

    ruby sinatra_worker.rb

Test with curl:

    curl http://localhost:1337/?name=Casimir
    curl -d '{"user":"popo"}' -H 'Content-Type: application/json'  http://localhost:1337/
