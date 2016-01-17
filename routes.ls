{map} = require \prelude-ls

store = (require "./blog-engine/fs-json-store.ls") {file-name: './store.json'}

service = (require "./blog-engine/index.ls") {store}


static-routes = ["/", "/edit/:postid"] |> map (r) -> [r, 'get', r, (req, res) -> res.render 'public/index.html']

api-call = (res, route, f) ->
    f!
    .then -> res.send it
    .catch -> 
        console.error route, it
        res.status 500 .send {error: true, errorContext: it.toString!}

make-route = (verb, path, f) ->
    * path, verb, path, (req, res) ->
        api-call res, path, -> (f req)

# these routes can be called by curl:
# curl --data 'title=Title&header=Header&body=Body' localhost:8600/api/new

# inject mockable dependencies here:
module.exports = ({on-change}) ->
    static-routes ++ [

        * make-route 'get', '/api/all', service.all

        * make-route 'get', '/api/get/:postid', (req) ->
            service.get (parse-int req.params.postid)

        * make-route 'post', '/api/new', (req) ->
            service.add req.body

        * make-route 'post', '/api/update', (req) ->
            service.update req.body

        * make-route 'post', '/api/delete/:postid', (req) ->
            service.remove (parse-int req.params.postid)

        * make-route 'post', '/api/restore', (req) ->
            service.restore req.body

        # * '/api/new', 'post', '/api/new', (req, res) ->
        #     api-call res, '/api/new', -> service.add req.body

        # * '/api/update', 'post', '/api/update', (req, res) ->
        #     api-call res, '/api/update', -> service.update req.body

        # * '/api/delete', 'post', '/api/delete/:postid', (req, res) ->
        #     api-call res, '/api/delete', -> service.remove (parse-int req.params.postid)

        # * '/api/restore', 'post', '/api/restore', (req, res) ->
        #     api-call res, '/api/restore', -> service.restore req.body
    ]