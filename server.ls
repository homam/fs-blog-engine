require! 'body-parser'
http = require 'http'
require! 'express'
{map, each} = require 'prelude-ls'
{http-port}:config = require './config'
http-port := process.env.PORT ? http-port


app = express!
    ..set 'views', __dirname + '/'
    ..engine '.html', (require 'ejs').__express
    ..set 'view engine', 'ejs'
    ..use body-parser.json!
    ..use body-parser.urlencoded {extended: false}
    ..use '/node_modules', express.static "#__dirname/node_modules"
    ..use '/public', express.static "#__dirname/public"



server = http.create-server app

io = (require 'socket.io') server

(require './routes') {
    on-change: ->
        # this callback is caalled every time a post created / updated / deleted
        # emit the change to all clients
        io.emit 'all-posts', it
    }
|> each ([, method]:route) -> app[method].apply app, route.slice 2


server.listen http-port 
console.log "Started listening on port #{http-port}"

