module.exports = ->

    # all :: _ -> Promise [Post]
    all: -> fetch '/api/all' .then (.json!)

    # get :: PostID (Integer) -> Promise Post
    get: (postid) -> new Promise (resolve, reject) ->
        fetch "/api/get/#{postid}" 
        .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
            if ok
                resolve res
            else
                reject res.error-context
        .catch -> 
            reject "Network error"
    
    # add :: NewPost -> Promise Post
    add: (new-post) -> new Promise (resolve, reject) ->
        fetch '/api/new', {
            method: 'post'
            headers:
                'Accept': 'application/json'
                'Content-Type': 'application/json'
            
            body: JSON.stringify new-post
        }
        .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
            if ok
                resolve res
            else
                reject res.error-context
        .catch -> 
            reject "Network error"

    # update :: Post -> Promise Post
    update: (post) -> new Promise (resolve, reject) ->
        fetch '/api/update', {
            method: 'post'
            headers:
                'Accept': 'application/json'
                'Content-Type': 'application/json'
            
            body: JSON.stringify post
        }
        .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
            if ok
                resolve res
            else
                reject res.error-context
        .catch -> 
            reject "Network error"

    remove: (postid) -> new Promise (resolve, reject) ->
        fetch "/api/delete/#{postid}", {
            method: 'post'
            headers:
                'Accept': 'application/json'
                'Content-Type': 'application/json'
            
            body: ''
        }
        .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
            if ok
                resolve res
            else
                reject res.error-context
        .catch -> 
            reject "Network error"