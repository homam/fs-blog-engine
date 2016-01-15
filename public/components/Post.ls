{create-class, create-factory, DOM:{div, button, input, textarea, form}}:React = require \react

module.exports = create-class do
    display-name: 'Post'

    render: ->
        div null, JSON.stringify @props.post, null, 4


    get-initial-state: -> {}
