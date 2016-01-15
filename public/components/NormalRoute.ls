{create-class, create-factory, DOM:{div, button}}:React = require \react
{find-DOM-node} = require \react-dom

module.exports = create-class do

    display-name: \Normal

    # render :: a -> ReactElement
    render: ->
        div null, 
            button do
                ref: \myb
                on-click: ~> fetch '/api/randoms?many=500' .then (.json!) .then ~> @set-state {data: it.data}
                "refresh"
            div null, JSON.stringify @state.posts


    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        {
            posts: []
        }

    # component-did-mount :: a -> Void
    component-did-mount: !->
        fetch '/api/all' .then (.json!) .then ~> @set-state {posts: it}