{create-class, create-factory, DOM:{div, button, input, textarea, form, h2, p}}:React = require \react
{find-DOM-node} = require \react-dom
{map, empty} = require 'prelude-ls'
Post = create-factory require './Post.ls'
Editor = create-factory <| (require './NewOrUpdatePost.ls').NewPostEditor
store = (require '../store.ls')!

module.exports = create-class do

    display-name: 'Index'

    # render :: a -> ReactElement
    render: ->
        div null, 
            if empty @state.posts   
                then div null, 
                    h2 class-name: 'welcome', "Welcome to your fresh empty blog!" 
                else @state.posts |> map (post) -> div key: post._id, Post {post}
            div do 
                null
                h2 null, 'New Post'
                Editor on-posted: ~>
                    window.scroll-to window.scroll-x, 0
                    store.all!.then ~> @set-state {posts: it}


    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        {
            posts: []
        }

    # component-did-mount :: a -> Void
    component-did-mount: !->

        # get all the posts
        store.all!.then ~> @set-state {posts: it}

        # listen to changes and re-render the posts on any change
        @socket = (require \socket.io-client) force-new: true
            .on 'all-posts', (all-posts) ~>
                @set-state posts: all-posts

    component-will-unmount: !->
        @socket.destroy!