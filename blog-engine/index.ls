{find} = require 'prelude-ls'
{promises:{bind-p, return-p}} = require 'async-ls'

module.exports = ({store}) ->

    # validate :: Post -> Promise Post
    # it rejects the promise chain if the input @blog@ does not validate against business rules
    validate = (blog) -> new Promise (resolve, reject) ->

        # check for the existence of String properties
        missing-prop = ["header", "title", "body"] |> find (p) -> !blog[p]
        if !!missing-prop
            reject "#{missing-prop} cannot be empty"
        else
            resolve blog

    add: (blog) ->
        <- bind-p validate blog
        store.add blog

    # get a post by @_id@. It returns an error if not post was found for the given @_id@.
    get: (_id) ->
        post <- bind-p store.get _id
        if !post
            Promise.reject "No post was found for the given ID: #{_id}"
        else
            return-p post

    update: (blog) ->
        <- bind-p validate blog
        store.update blog

    all: store.all-posts