// Generated by CoffeeScript 1.4.0
(function() {
  var LISTENING_PORT, app, express, io, server;

  io = require('socket.io');

  express = require('express');

  LISTENING_PORT = process.env.PORT;

  app = express();

  server = require('http').createServer(app);

  io = io.listen(server);

  server.listen(LISTENING_PORT);

  app.get('/', function(req, res) {
    console.log('hola');
    return res.sendfile(__dirname + '/client.html');
  });

  /*
  # Via express 2.x server
  app = express.createServer()
  io = io.listen app
  app.listen LISTENING_PORT
  */


  /*
  # Standalone
  io = io.listen LISTENING_PORT
  */


  io.sockets.on('connection', function(sockets) {
    console.log('user connected to server');
    return socket.on('some event', function(data) {
      console.log(data);
      socket.emit('event', {
        some: 'data'
      });
      return io.sockets.emit('chat message', data);
    });
  });

  console.log("socket.io listening at " + process.env.IP + ":" + process.env.PORT);

}).call(this);
