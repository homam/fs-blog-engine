{map} = require \prelude-ls

store = (require "./blog-engine/fs-json-store.ls") {file-name: './store.json'}

service = (require "./blog-engine/index.ls") {store}


static-routes = ["/", "/normal", "/beta"] |> map (r) -> [r, 'get', r, (req, res) -> res.render 'public/index.html']

# inject mockable dependencies here:
module.exports = ->
    static-routes ++ [
        * '/api/randoms', 'get', '/api/randoms', (req, res) -> 
            how-many = parse-int req.query.many
            res.send {
                data: [1 to how-many] |> map (-> Math.random!)
            }

        * '/api/all', 'get', '/api/all', (req, res) ->
            service.all!
                .then -> res.send it
                .catch -> 
                    console.error "/api/all", it
                    res.status 500 .send {error: true, errorContext: it.toString!}

        # curl --data 'title=Title&header=Header&body=Body' localhost:8600/api/new
        * '/api/new', 'post', '/api/new', (req, res) ->
            console.log \new, req.body
            service.add req.body
                .then -> res.send it
                .catch ->
                    console.error "/api/new", it
                    res.status 500 .send {error: true, errorContext: it.toString!}
    ]