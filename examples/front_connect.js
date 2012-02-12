var redis = require('redis'),
    connect = require('connect'),
    tempest = require('tempest');

var cpt = 0;

//[TODO] see https://github.com/visionmedia/connect-redis
var TempestStore = function() {};
TempestStore.prototype.get = function(sid, cb) {

};
TempestStore.prototype.set = function(sid, session, cb) {
    //hmset
};
TempestStore.prototype.destroy = function(sid, cb) {

};

var work = function(req, res, next) {
    if (req.headers['content-length']) {
        var size = parseInt(req.headers['content-length'], 10);
        var b = new Buffer(size);
        var copied = 0;
        req.on('data', function(data) {
            data.copy(b, copied);
            copied += data.length;
            if (copied === size) {
                work_with_body(req, res, next, b);
            }
        });
    } else {
        work_with_body(req, res, next);
    }
    //console.log('todo', cpt);
};

var work_with_body  = function(req, res, next, body) {
    cpt += 1;
    args = {
        headers: req.headers,
        method: req.method,
        url: req.url
    };
    if (body !== undefined) {
        args['body'] = body.toString('utf8');
    }
    var job = cluster.work('sinatra', 'url', [args], cluster.self(),
            function() {});
    cluster.on('id:url:' + job, function(args) {
        //status, headers, body) {
        res.statusCode = args[0];
        var headers = args[1];
        for (key in headers) {
            res.setHeader(key, headers[key]);
        }
        res.write(args[2]);
        res.end(); //FIXME Why only end doesn't work?
    });
};

var cluster = tempest.createCluster(function() {
    connect(
        connect.favicon(),
        connect.cookieParser(),
        connect.session({
            store: new TempestStore(),
            secret: 'Tempest rulez'}),
        connect.router(function(app) {

            app.get('/info', function(req, res, next) {
                res.end('' + cpt);
            });
            app.get('*', work);
            app.post('*', work);
        })
    ).listen(1337);
});
