{map} = require \prelude-ls
{promises:{bind-p, return-p}} = require 'async-ls'
store = (require "./blog-engine/fs-json-store.ls") {file-name: './store.json'}
service = (require "./blog-engine/index.ls") {store}


static-routes = ["/", "/edit/:postid"] |> map (r) -> [r, 'get', r, (req, res) -> res.render 'public/index.html']

# utility function to handle errors returned by API calls
# res :: Response
# route :: String
# f :: -> Promise a
api-call = (res, route, f) ->
    f!
    .then -> res.send it
    .catch -> 
        console.error route, it
        res.status 500 .send {error: true, errorContext: it.to-string!}

# make a route
# verb :: String (get | post)
# path :: String
# f :: Request -> Promise a
make-route = (verb, path, f) ->
    * path, verb, path, (req, res) ->
        api-call res, path, -> (f req)


# these routes can be called by curl:
# curl --data 'title=Title&header=Header&body=Body' localhost:8600/api/new

# inject mockable dependencies here:
module.exports = ({on-change}) ->

    # f :: Promise r
    propagate-change = (f) ->
        r <- bind-p f
        set-immediate ->
            # get all posts and pass them to @on-change@ callback
            posts <- bind-p service.all!
            on-change posts
        return-p r

    static-routes ++ [

        * make-route 'get', '/api/all', service.all

        * make-route 'get', '/api/get/:postid', (req) ->
            service.get (parse-int req.params.postid)

        * make-route 'post', '/api/new', (req) ->
            propagate-change service.add req.body

        * make-route 'post', '/api/update', (req) ->
            propagate-change service.update req.body

        * make-route 'post', '/api/delete/:postid', (req) ->
            propagate-change service.remove (parse-int req.params.postid)

        * make-route 'post', '/api/restore', (req) ->
            propagate-change service.restore req.body
    ]