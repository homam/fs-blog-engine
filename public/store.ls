require! 'whatwg-fetch'


# helper function for making GET or POST requests to the API
# GET requests have a body = null
fetch1 = (path, body = null) -> new Promise (resolve, reject) ->
    fetch do 
        path
        # the body of a GET request is empty, the body of a POST request is a JSON object
        if body == null then {} else {
            method: 'post'
            headers:
                'Accept': 'application/json'
                'Content-Type': 'application/json'
            
            body: JSON.stringify body
        }
    .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
        if ok
            resolve res
        else
            reject res.error-context
    .catch -> 
        reject "Network error"


# public interface: 

module.exports = ->

    # all :: _ -> Promise [Post]
    all: -> fetch1 '/api/all'

    # get :: PostID (Integer) -> Promise Post
    get: (postid) -> fetch1 "/api/get/#{postid}"
    
    # add :: NewPost -> Promise Post
    add: (new-post) -> fetch1 '/api/new', new-post

    # update :: Post -> Promise Post
    update: (post) ->  fetch1 '/api/update', post

    # remove :: PostId (Integer) -> Promise Post
    remove: (postid) -> fetch1 "/api/delete/#{postid}", {}

    # restore :: Post -> Promise Post
    restore: (post) -> fetch1 '/api/restore', post