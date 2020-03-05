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
  var AudioContext = window.AudioContext // Default
    || window.webkitAudioContext // Safari and old versions of Chrome
    || false;

  if (AudioContext) {
    var context = new AudioContext();

    if (context.state == 'suspended') {
      document.querySelector('body').addEventListener('click', function() {
        context.resume().then(() => {
          console.log('Playback resumed successfully');
        });
      });

      alert('Click anywhere to enable audio');
    }

    writeLog = function(msg) {
      $('.log-container ul').append($('<li/>').text(msg));
    }

    playSound = function(sound, reverse, delay) {
      var request = new XMLHttpRequest();

      request.open('GET', sound, true);
      request.responseType = 'arraybuffer';

      request.addEventListener('load', function() {
        context.decodeAudioData(request.response, function(buffer) {
          playBuffer(buffer, reverse, delay);
        });
      });

      request.send();
    }

    playBuffer = function(buffer, reverse, delay) {
      var source, delay, feedback, filter, i;

      source = context.createBufferSource();

      if (delay) {
        delay = context.createDelay();
        delay.delayTime.value = 0.3;

        feedback = context.createGain();
        feedback.gain.value = 0.6;

        filter = context.createBiquadFilter();
        filter.frequency.value = 1000;

        delay.connect(feedback);
        feedback.connect(filter);
        filter.connect(delay);

        source.connect(delay);
        delay.connect(context.destination);
      }

      source.connect(context.destination);

      if (reverse) {
        for (i=0; i < buffer.numberOfChannels; i++) {
          Array.prototype.reverse.call(buffer.getChannelData(i));
        }
      }

      source.buffer = buffer;
      source.start();
    }

    setCoverImage = function(image) {
      var $container = $('.cast-container');

      $container.css({
        'background-image': "url(" + image + ")",
      });
    }
  } else {
    alert('Sorry but your browser does not support the Web Audio API');
  }
})();
