var redis = require('redis'),
    connect = require('connect'),
    tempest = require('tempest');

var cpt = 0;

var cluster = tempest.createCluster(function() {
    var web = connect.createServer(
        connect.favicon(),
        connect.router(function(app) {

            app.get('/info', function(req, res, next) {
                res.end("" + cpt);
            });

            app.get('*', function(req, res, next) {
                cpt += 1;
                args = {
                    headers: req.headers,
                    method: req.method,
                    url: req.url
                };
                var job = cluster.work('sinatra', 'url', [args], cluster.self(),
                    function() {});
                cluster.on('id:url:' + job, function(args) {
                    //status, headers, body) {
                    res.writeHead(args[0], args[1]);
                    res.write(args[2]);
                    res.end();
                });
            });
        })
    );

    web.listen(1337);
});
