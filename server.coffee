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
    console.log 'a user is connected to server'
    socket.send 'connection received by the server'
    # using send all messages are in the same callback
    socket.on 'message', (message) ->
        console.log message
        socket.emit 'news', { hello: 'world' }
        # emit a message to all users
        #io.socets.emit 'news', {hello: 'world'}
        # emit a message to all users but the one connected
        # socket.broadcast.emit(news’, {hello: 'world'});
    
    socket.on 'my other event', (data) ->
        console.log data
    
    socket.on 'execute_console', (func) ->
        func()

    socket.on 'sendName', (name) ->
        console.log "storing userName, #{name}"
        socket.set 'userName', name, () ->
            socket.emit 'nameReceived'

    socket.on 'getName', () ->
        socket.get 'userName', (err, ctxName) ->
            console.log "emitting getName, #{ctxName}" 
            socket.emit 'getName', ctxName

    # Rooms
    socket.on 'addToRoom', (roomName) ->
        # broadcast everybody but socket
        welcomeMsg = "a new user has joined your room"
        io.sockets.in(romName).emit welcomeMsg
        socket.join roomName

    socket.on 'removeFromRoom', (roomName) ->
        # broadcast everyone including socket
        leftMsg = "a user has left this room"
        socket.broadcast.to(roomName).emit leftMsg 
        socket.leave roomName

# configuring a socket.io server
io.configure 'production', () ->
    io.enable 'browser client etag'
    io.set 'log level', 1
    io.set 'transports', ['websocket', 'flashsocket', 'xhr-polling']

# setting up the server to allow multiple connections
chat =  io
    .of '/chat'
    .on 'connection', (socket) ->
         # send message to client as usual
         socket.emit 'message', { that: 'only', socket: 'will get'}
         # broadcast to everyone in this namespace
         chat.emit 'message', { everyone: 'in', '/chat': 'will get'}

news = io
    .of '/news'
    .on 'connection', (socket) ->
        socket.emit 'item', { news: 'item'}

