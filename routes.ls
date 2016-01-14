{map} = require \prelude-ls

static-routes = ["/", "/normal", "/beta"] |> map (r) -> [r, 'get', r, (req, res) -> res.render 'public/index.html']

# inject mockable dependencies here:
module.exports = ->
    static-routes ++ [
        * '/api/randoms', 'get', '/api/randoms', (req, res) -> 
            how-many = parse-int req.query.many
            res.send {
                data: [1 to how-many] |> map (-> Math.random!)
            }
    ]