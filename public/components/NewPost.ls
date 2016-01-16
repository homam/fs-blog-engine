{create-class, create-factory, DOM:{div, button, input, textarea, form}}:React = require \react
{find-DOM-node} = require \react-dom

module.exports = create-class do
    display-name: 'New-Post'

    render: ->
        div class-name: 'editor',
            div null, 
                input class-name: 'title', placeholder: 'Title', value: @props.post?.title, on-change: (event) ~> 
                    @props.on-change title: event.target.value
            div null,
                textarea class-name: 'header', placeholder: 'Header', value: @props.post?.header, on-change: (event) ~> 
                    @props.on-change header: event.target.value
            div null,
                textarea class-name: 'body', placeholder: 'Body', value: @props.post?.body, on-change: (event) ~> 
                    @props.on-change body: event.target.value