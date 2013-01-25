io = require 'socket.io'
express = require 'express'

LISTENING_PORT = 8010
HOST = "http://localhost"

# Via express 3.x server
app = express()
server = require('http').createServer app
io = io.listen server

server.listen LISTENING_PORT

app.get '/', (req, res) ->
    console.log 'hola'
    res.sendfile __dirname + '/client.html'

###
# Via express 2.x server
app = express.createServer()
io = io.listen app
app.listen LISTENING_PORT
###

###
# Standalone
io = io.listen LISTENING_PORT
###

# Now, let's set up and start listening for events
io.sockets.on 'connection', (socket) ->
    socket.emit 'news', { hello: 'world' }
    socket.on 'my other event', (data) ->
        console.log data