fs = require 'fs'
{find, find-index, reverse} = require 'prelude-ls'
{promises:{from-error-value-callback, bind-p, return-p}} = require 'async-ls'

# s = (require "./fs-json-store.ls") {file-name: '../store.json'}
# s.allPosts.catch (-> console.log "Error: #it") .then (-> console.log it)

# this storage adds these three fields to each item it store:
# _id :: TimeStamp (unique)
# _date-created :: TimeStamp
# _date-last-updated :: TimeStamp
module.exports = ({file-name}) ->
    
    all-posts = ->
        content <- bindP (from-error-value-callback fs.read-file) file-name, {encoding: 'utf8'}
        if content.length == 0
            # empty / fresh storage
            return-p []
        else 
            return-p (JSON.parse content)

    save = (posts) ->
        (from-error-value-callback fs.write-file) file-name, (JSON.stringify posts, null, 4), 'utf8'

    get = (_id) ->
        posts <- bind-p all-posts!
        return-p <| posts |> find (p) -> p._id == _id
        
    # add :: Post -> Promise Post
    add: (post) ->
        now = new Date!.value-of! 
        post._id = now
        post._date-created = now
        post._date-last-updated = now
        posts <- bind-p all-posts!
        posts.push post
        <- bind-p save posts
        return-p post

    # get :: ID -> Promise Post
    get: get

    update: (post) ->
        posts <- bind-p all-posts!
        index = posts |> find-index (p) -> p._id == post._id

        if 'Undefined' == typeof! index
            Promise.reject "No Post was found for the given _id: #{post._id} (update)"
        else

            old-post = posts[index]

            {_id, _date-created, _date-last-update} = old-post
            updated-post = old-post <<< post <<< {_id, _date-created, _date-last-update: new Date!.value-of!}
            
            posts[index] = updated-post
            <- bind-p save posts

            return-p updated-post


    remove: (_id) ->

        posts <- bind-p all-posts!
        index = posts |> find-index (p) -> p._id == _id

        if 'Undefined' == typeof! index
            Promise.reject "No Post was found for the given _id: #{_id} (remove)"
        else
            old-post = posts[index]

            posts := (posts.slice 0, index) ++ (posts.slice index + 1)
            <- bind-p save posts

            return-p old-post

    all-posts: -> all-posts! `bind-p` reverse