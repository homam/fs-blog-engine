{find} = require 'prelude-ls'
{create-class, create-factory, DOM:{div, button, form, a}}:React = require \react
{find-DOM-node} = require 'react-dom'
require! 'react-router'
Link = create-factory react-router.Link
NewPost = create-factory require './NewPost.ls'
Dialog = create-factory require './Dialog.ls'
store = (require '../store.ls')!


create-component = (is-new) -> 
    if is-new
        success-message = 'New post added.'
        action = store.add
    else
        success-message = 'Post was updated.'
        action = store.update

    create-class do

        display-name: \New-Or-Update-Post

        # render :: a -> ReactElement
        render: ->
            
            div class-name: 'editor',

                if !!@state.deleting
                    Dialog do 
                        question: 'Are you sure you want to delete this post?'
                        on-no: ~> @set-state deleting: false
                        on-yes: ~> 
                            store.remove @state.post._id
                                .then ~>
                                    @set-state {
                                        # post: if is-new then {} else it
                                        message: 
                                            success: true
                                            text: 'This post was deleted.'
                                        deleted: true
                                    }
                                .catch ~>
                                    @set-state {
                                        message: 
                                            success: false
                                            text: "Error: #{it}"
                                    }

                form do
                    null

                    NewPost ref: 'newpost' post: @state.post, on-change: (pc) ~>
                        post = @state.post
                        @set-state post: post <<< pc

                    if !@state.deleted
                        div class-name: 'controls',

                            if !is-new
                                button do
                                    type: 'button'
                                    on-click: ~> @set-state deleting: true
                                    "Delete"

                            button do 
                                type: 'button'
                                on-click: ~>
                                    post = @state.post

                                    missing-prop = ["title", "header", "body"] |> find (p) -> !post[p]

                                    if !!missing-prop
                                        @set-state {
                                            message: 
                                                success: false
                                                text: "All fields are mandatory. Please fill the #{missing-prop} field."
                                                field: missing-prop
                                        }
                                    else
                                        action post
                                            .then ~>
                                                @set-state {
                                                    post: if is-new then {} else it
                                                    message: 
                                                        success: true
                                                        text: success-message
                                                }
                                                if !!@props.on-posted
                                                    @props.on-posted it
                                            .catch ~>
                                                @set-state {
                                                    message: 
                                                        success: false
                                                        text: "Error: #{it}"
                                                }


                                # the text of the button
                                if is-new then "Post" else "Update"


                # there is a message to be displayed. a message can be either successful or an error
                if !!@state.message
                    div class-name: "message #{if @state.message.success then 'success' else 'error'}", 
                        div null, @state.message.text
                        
                        if @state.message.success
                            div class-name: 'controls', 
                                
                                # provide a link to home only if action was successful
                                Link do 
                                    to: '/'
                                    on-click: ~> @set-state message: null
                                    'Back to home'

                                if @state.deleted
                                    a do 
                                        href: 'javascript: void(0)'
                                        on-click: ~>
                                            store.restore @state.post
                                                .then ~>
                                                    @set-state {
                                                        # post: if is-new then {} else it
                                                        message: 
                                                            success: true
                                                            text: 'This post was resrored.'
                                                        deleting: false
                                                        deleted: false
                                                    }
                                                .catch ~>
                                                    @set-state {
                                                        message: 
                                                            success: false
                                                            text: "Error: #{it}"
                                                    }
                                        'Restore'

                        # provide a link to focus on the missing-prop field
                        else if !!@state.message.field
                            a do
                                href: 'javascript: void(0)', on-click: ~>
                                    @refs.newpost.refs[@state.message.field].focus!
                                'Fix it'



        # get-initial-state :: a -> UIState
        get-initial-state: -> 
            {
                post: {}
                message: null # {text :: String, success :: Boolean}
                deleting: false
                deleted: false
            }

        # component-will-mount :: a -> Void
        component-will-mount: !->
            if !is-new
                # get the post to be edited
                store.get @props.postid
                    .then ~> @set-state {post: it}
                    .catch ~> alert it


module.exports = {
    ExistingPostEditor: create-component false
    NewPostEditor: create-component true
}