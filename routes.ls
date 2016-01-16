{map} = require \prelude-ls

store = (require "./blog-engine/fs-json-store.ls") {file-name: './store.json'}

service = (require "./blog-engine/index.ls") {store}


static-routes = ["/", "/edit/:postid"] |> map (r) -> [r, 'get', r, (req, res) -> res.render 'public/index.html']

# inject mockable dependencies here:
module.exports = ->
    static-routes ++ [

        * '/api/all', 'get', '/api/all', (req, res) ->
            service.all!
                .then -> res.send it
                .catch -> 
                    console.error "/api/all", it
                    res.status 500 .send {error: true, errorContext: it.toString!}

        * '/api/get', 'get', '/api/get/:postid', (req, res) ->
            service.get (parse-int req.params.postid)
                .then -> res.send it
                .catch -> 
                    console.error "/api/get", it
                    res.status 500 .send {error: true, errorContext: it.toString!}


        # curl --data 'title=Title&header=Header&body=Body' localhost:8600/api/new
        * '/api/new', 'post', '/api/new', (req, res) ->
            service.add req.body
                .then -> res.send it
                .catch ->
                    console.error "/api/new", it
                    res.status 500 .send {error: true, errorContext: it.toString!}

        * '/api/update', 'post', '/api/update', (req, res) ->
            service.update req.body
                .then -> res.send it
                .catch ->
                    console.error "/api/update", it
                    res.status 500 .send {error: true, errorContext: it.toString!}

        * '/api/delete', 'post', '/api/delete/:postid', (req, res) ->
            service.remove (parse-int req.params.postid)
                .then -> res.send it
                .catch -> 
                    console.error "/api/delete", it
                    res.status 500 .send {error: true, errorContext: it.toString!}
    ]