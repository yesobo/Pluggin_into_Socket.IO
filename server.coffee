io = require 'socket.io'
express = require 'express'

LISTENING_PORT = process.env.PORT

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
io.sockets.on 'connection', (sockets) ->
    console.log 'user connected to server'
    socket.on 'some event', (data) ->
        # We've received some data. Let's just log it
        console.log data
        
        # Now let's reply
        socket.emit 'event', {some: 'data'}
        
        # Informs every client
        io.sockets.emit 'chat message', data

console.log "socket.io listening at #{process.env.IP}:#{process.env.PORT}"
        
