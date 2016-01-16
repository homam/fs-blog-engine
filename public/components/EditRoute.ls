{create-class, create-factory, DOM:{div, button, form}}:React = require 'react'
Editor = create-factory <| (require './NewOrUpdatePost.ls').ExistingPostEditor


module.exports = create-class do

    display-name: \Edit

    # render :: a -> ReactElement
    render: ->
                
        div null,

            Editor postid: @props.params.postid

    # get-initial-state :: a -> UIState
    get-initial-state: ->  { }

    # component-will-mount :: a -> Void
    component-will-mount: !->

