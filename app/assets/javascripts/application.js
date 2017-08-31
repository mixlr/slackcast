// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require tuna
//= require_tree .

var writeLog, playSound, playBuffer;

(function() {
  var context = new AudioContext();
  var tuna = new Tuna(context);

  writeLog = function(msg) {
    $('.log-container ul').append($('<li/>').text(msg));
  }

  playSound = function(sound, effects) {
    var request = new XMLHttpRequest();

    request.open('GET', sound, true);
    request.responseType = 'arraybuffer';

    request.addEventListener('load', function() {
      context.decodeAudioData(request.response, function(buffer) {
        playBuffer(buffer, effects);
      });
    });

    request.send();
  }

  playBuffer = function(buffer, effects) {
    var source = context.createBufferSource();
    var nodes = [source];

    for (var i=0; i < effects.length; i++) {
      var effectName = effects[i].name;
      var effectArgs = effects[i].args;
      var node = new tuna[effectName](effectArgs);

      nodes[nodes.length - 1].connect(node);
      nodes.push(node);
    }

    nodes[nodes.length - 1].connect(context.destination);

    source.buffer = buffer;
    source.start();
  }
})();
