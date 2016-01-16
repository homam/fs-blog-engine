{create-class, create-factory, DOM:{div, button, form}}:React = require \react
{find-DOM-node} = require \react-dom
require! \react-router
Link = create-factory react-router.Link
NewPost = create-factory require './NewPost.ls'
store = (require '../store.ls')!


module.exports = create-class do

    display-name: \Edit

    # render :: a -> ReactElement
    render: ->
        
        div null,

            if !!@state.message
                div class-name: "message #{if @state.message.success then 'success' else 'error'}", 
                    div null, @state.message.text
                    Link to: "/", 'Back to home'

            form do
                null

                NewPost post: @state.post, on-change: (pc) ~>
                    post = @state.post
                    @set-state post: post <<< pc

                button do 
                    type: 'button'
                    on-click: ~>
                        store.update @state.post
                            .then ~>
                                @set-state {
                                    post: it
                                    message: 
                                        success: true
                                        text: "Past was updated"
                                }
                            .catch ~>
                                @set-state {
                                    message: 
                                        success: false
                                        text: "Error: #{it}"
                                }
                    "Update"

    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        {
            post: null
            message: null # {text :: String, success :: Boolean}
        }

    # component-will-mount :: a -> Void
    component-will-mount: !->
        # get the post to be edited
        store.get @props.params.postid
            .then ~> @set-state {post: it}
            .catch ~> alert it