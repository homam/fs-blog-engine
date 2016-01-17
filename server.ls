require! 'body-parser'
{http-port}:config = require './config'
http = require 'http'
require! 'express'
{map, each} = require 'prelude-ls'

app = express!
    ..set \views, __dirname + \/
    ..engine \.html, (require \ejs).__express
    ..set 'view engine', \ejs
    ..use body-parser.json!
    ..use body-parser.urlencoded {extended: false}
    ..use \/node_modules, express.static "#__dirname/node_modules"
    ..use \/public, express.static "#__dirname/public"

(require \./routes) {}
    |> each ([, method]:route) -> app[method].apply app, route.slice 2


http-port := process.env.PORT ? http-port

server = http.create-server app
server.listen http-port 

console.log "Started listening on port #{http-port}"

WebSocketServer = require 'ws' .Server
wss = new WebSocketServer server: server
wss.on 'connection', (ws) ->
  timer = setInterval do 
    ->
        ws.send (JSON.stringify new Date!), (->)
    1000

  console.log "websocket connection open"

  ws.on 'close', ->
    console.log "websocket connection close"
    clearInterval timer