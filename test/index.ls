assert = require 'assert'
routes = require '../routes.ls'
{find, last} = require 'prelude-ls'
{promises:{from-error-value-callback, bind-p, return-p}} = require 'async-ls'

wait = (ms) -> new Promise (resolve) ->
    <- set-timeout _, ms
    resolve!


describe 'fs-json-storage', ->
    
    file-name = './test/store.json'
    
    before-each ->
        fs = require 'fs'
        (from-error-value-callback fs.write-file) file-name, '', 'utf8'

    new-store = ->
        (require "../blog-engine/fs-json-store.ls") {file-name}

    add = (store, title = 'first-post') ->
        store.add {title: title, author: 'homam',  header: 'header', body: 'body'} 

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

    specify 'updating a post must maintain its index', ->
        
        store = new-store!

        # post1
        <- bind-p add store
        <- bind-p wait 20

        # post2
        post2 <- bind-p add store
        <- bind-p wait 20

        # post3
        <- bind-p add store

        updated-body = "updated body"
        post2.body = updated-body

        _ <- bind-p store.update post2

        posts <- bind-p store.all-posts!

        assert posts[1].body == updated-body,  
            "posts order changed after an update, second item must have been updated\n#{JSON.stringify posts, null, 2}"

    specify 'deleting a post', ->
        
        store = new-store!

        post <- bind-p add store

        deleted-post <- bind-p store.remove post._id

        assert deleted-post._id == post._id, "deleted post _id is not correct"

        store.all-posts! .then -> 
            assert it.length == 0, "dataset is not empty"

    specify 'inserting a post', ->

        store = new-store!

        post1 <- bind-p add store, 'first'
        <- bind-p wait 10
        post2 <- bind-p add store, 'second'
        <- bind-p wait 10
        post3 <- bind-p add store, 'third'
        <- bind-p wait 10

        deleted-post <- bind-p store.remove post2._id

        _ <- bind-p store.insert deleted-post

        posts <- bind-p store.all-posts! 
        
        assert posts.length == 3, "post was not inserted"
        assert posts[1]._id == post2._id, "post was not inserted at the correct index"




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