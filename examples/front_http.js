var http = require('http'),
    tempest = require('tempest');

tempest.createCluster(function() {
    http.createServer(tempest.http.work(this, 'sinatra')).
        listen(1337);
});
