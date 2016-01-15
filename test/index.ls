assert = require 'assert'
routes = require '../routes.ls'
{find, last} = require 'prelude-ls'
{promises:{from-error-value-callback, bind-p, return-p}} = require 'async-ls'

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




describe 'fs-json-storage', ->
    
    file-name = './test/store.json'
    
    before-each ->
        fs = require 'fs'
        (from-error-value-callback fs.write-file) file-name, '', 'utf8'

    new-store = ->
        (require "../blog-engine/fs-json-store.ls") {file-name}

    add = (store) ->
        store.add {title: 'first-post', author: 'homam',  header: 'header', body: 'body'} 

    specify 'a fresh dataset must be empty', ->
        new-store!.all-posts! .then -> 
            assert it.length == 0, "dataset is not empty \n#{JSON.stringify it}"

    specify 'adding a post to the dataset must change the size of the dataset', -> 
        
        store = new-store!

        post <- bind-p add store

        assert !!post._id, "newly added post is missing an _id field"

        store.all-posts! .then -> 
            assert it.length == 1, "dataset must have only 1 item \n#{JSON.stringify it}"

    specify 'getting a post from the dataset', ->
        
        store = new-store!

        post <- bind-p add store

        store.get post._id .then -> 
            assert !!it, "newly added post was not found in the dataset: \n#{JSON.stringify post}"
            assert it._id == post._id, "get failed to retrieve a post with the expected _id of #{post._id} \n#{JSON.stringify it}"
    
    specify 'updating a post', ->
        
        store = new-store!

        post <- bind-p add store

        post.body = "updated body"

        updated-post <- bind-p store.update post

        store.get post._id .then -> 
            assert !!it, "newly updated post was not found in the dataset: \n#{JSON.stringify post}"
            assert it._id == post._id, "get failed to retrieve a newly updated post with the expected _id of #{post._id}"
            assert it.body == post.body, "post faield to update \nOld: #{post.body} \nNew: #{it.body}"

    specify 'deleting a post', ->
        
        store = new-store!

        post <- bind-p add store

        deleted-post <- bind-p store.remove post._id

        assert deleted-post._id == post._id, "deleted post _id is not correct"

        store.all-posts! .then -> 
            assert it.length == 0, "dataset is not empty"




describe 'blog-engine', ->
    
    file-name = './test/store.json'
    
    # empty the dataset
    before ->
        fs = require 'fs'
        (from-error-value-callback fs.write-file) file-name, '', 'utf8'

    store = (require "../blog-engine/fs-json-store.ls") {file-name}

    service = (require "../blog-engine/index.ls") {store}

    add = -> service.add {title: 'first-post', author: 'homam',  header: 'header', body: 'body'}

    specify 'adding a post to the dataset must change the size of the dataset', -> 

        post <- bind-p add!

        assert !!post

        posts <- bind-p service.all!

        assert posts.length == 1, "dataset must have only 1 item"