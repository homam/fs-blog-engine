require! \../../config.ls
{clone-element, create-class, create-factory, DOM:{div}}:React = require 'react'
{render} = require 'react-dom'
require! 'react-router'
Router = create-factory react-router.Router
Route = create-factory react-router.Route
IndexRoute = create-factory react-router.IndexRoute
Link = create-factory react-router.Link

App = create-class do

    display-name: 'App'

    # render :: a -> ReactElement
    render: ->
        div class-name: 'app',

            div null,
                @props.children

            div {class-name: 'building'}, 'Building...' if @state.building

    # get-initial-state :: a -> UIState
    get-initial-state: -> building: false

    # component-did-mount :: a -> Void
    component-will-mount: !->
        # gulp auto-reload used during development
        if !!config?.gulp?.reload-port
            (require 'socket.io-client') "http://localhost:#{config.gulp.reload-port}"
                ..on 'build-start', ~> @set-state building: true
                ..on 'build-complete', -> window.location.reload!

render do 
    Router do 
        history: react-router.browser-history
        Route do 
            name: 'app'
            path: '/'
            component: App
            IndexRoute component: (require './IndexRoute.ls')
            Route name: 'edit', path: '/edit/:postid' component: (require './EditRoute.ls')
    document.get-element-by-id 'mount-node'


