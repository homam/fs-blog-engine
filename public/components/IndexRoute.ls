{create-class, create-factory, DOM:{div, button, input, textarea, form}}:React = require \react
{find-DOM-node} = require \react-dom
{map} = require 'prelude-ls'
Post = create-factory require './Post.ls'
NewPost = create-factory require './NewPost.ls'

module.exports = create-class do

    display-name: 'Index'

    # render :: a -> ReactElement
    render: ->
        div null, 
            button do
                ref: \myb
                on-click: ~> fetch '/api/randoms?many=500' .then (.json!) .then ~> @set-state {data: it.data}
                "refresh"
            @state.posts |> map (post) -> div key: post._id, Post {post}
            div null, NewPost {
                post: @state.new-post
                on-new-post: ~>
                    fetch '/api/all' .then (.json!) .then ~> @set-state {posts: it}
            }

    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        {
            posts: []
        }

    # component-did-mount :: a -> Void
    component-did-mount: !->
        fetch '/api/all' .then (.json!) .then ~> @set-state {posts: it}