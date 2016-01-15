{find} = require 'prelude-ls'
{promises:{bind-p, return-p}} = require 'async-ls'

module.exports = ({store}) ->

    validate = (blog) -> new Promise (resolve, reject) ->
        missing-prop = ["header", "title", "body"] |> find (p) -> !blog[p]
        if !!missing-prop
            reject "#{missing-prop} cannot be empty"
        else
            resolve blog

    add: (blog) ->
        <- bind-p validate blog
        store.add blog

    all: store.all-posts