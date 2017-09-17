App.cast = App.cable.subscriptions.create({
    channel: 'CastChannel',
    code_version: App.CODE_VERSION
  }, {
    connected: function() {
      writeLog('Connected');
    },

    disconnected: function() {
      writeLog('Disconnected');
    },

    rejected: function() {
      writeLog('Detected running out-of-date code. Reloading...');

      setTimeout(function() {
        window.location.reload();
      }, 1000);
    },

    received: function(data) {
      writeLog('Received message: ' + JSON.stringify(data));

      switch(data.command) {
        case 'play_sound':
          playSound(data.sound, data.effects);
          break;
        case 'silence':
          silence();
          break;
        default:
          writeLog('Unknown data received: ' + JSON.stringify(data));
      }
    }
});
