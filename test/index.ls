routes = require '../routes.ls'
{find, last} = require 'prelude-ls'

describe 'routes', ->
    specify 'duck must return an array of random numbers with the size of many', -> new Promise (resolve, reject) ->
        handler = routes {} |> find (.0 == '/api/randoms') |> last
        req = {query: many: '500'}
        res = {
            send: (json) -> 
                if json.data.length == 500
                    resolve null
                else
                    reject "{data} with data.length == 500 expected, instead got: \n#{JSON.stringify json}"
        }

        handler req, res
