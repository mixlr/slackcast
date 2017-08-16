App.cast = App.cable.subscriptions.create("CastChannel", {
  connected: function() {
    writeLog('Connected');
  },

  disconnected: function() {
    writeLog('Disconnected');
  },

  received: function(data) {
    writeLog('Received message: ' + JSON.stringify(data));

    switch(data.command) {
    case 'sound':
      playSound(data.args.url, data.args.reverse, data.args.delay);
      break;
    case 'websocket_sound':
      playWebsocket(data.args.data);
      break;
    case 'image':
      setCoverImage(data.args.url);
      break;
    }
  }
});
