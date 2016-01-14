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
            div null, JSON.stringify @state.data


    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        {
            data: []
        }

    # component-did-mount :: a -> Void
    component-did-mount: !->
        find-DOM-node @refs.myb .scrollIntoView!