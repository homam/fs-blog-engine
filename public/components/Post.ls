{create-class, create-factory, DOM:{div, span, article, section, h2, button, input, textarea, form}}:React = require \react
moment = require 'moment'
require! \react-router
Link = create-factory react-router.Link


module.exports = create-class do
    display-name: 'Post'

    render: ->
        {title, header, body, author}:post = @props.post
        article class-name: 'post', 
            div null
                h2 null, title
                Link class-name: 'edit' to: "/edit/#{post._id}", '[Edit]'
            div null, 
                span null, (moment post._date-created).from!
            section null, body 


    get-initial-state: -> {}
