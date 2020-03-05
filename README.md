# Slackcast [![pipeline status](https://gitlab.com/mixlr/slackcast/badges/master/pipeline.svg)](https://gitlab.com/mixlr/slackcast/commits/master) [![coverage report](https://gitlab.com/mixlr/slackcast/badges/master/coverage.svg)](https://gitlab.com/mixlr/slackcast/commits/master)

## Overview

Trigger sounds via Slack Real-time API -> Rails / ActionCable -> Browser -> Chromecast.

Bonus integration with [Tuna.js](https://github.com/Theodeus/tuna) to trigger per-sound effects.

## Usage

- Play a sound:

  `@mick moo`

- Add an Tuna effect node:

  `@mick moo ping_pong_delay`

- Effects can also be written in CamelCase:

  `@mick moo PingPongDelay`

- Pass arguments to the effect:

  `@mick moo delay(delayTime=1000)`

- Pass multiple arguments:

  `@mick moo delay(delayTime=300 feedback=0.55 cutoff=1000)`

- Arguments can also be written JSON-style:

  `@mick moo delay(delayTime: 300, feedback: 0.55, cutoff: 1000)`

- Chain multiple effects, some with arguments:

  `@mick moo wah_wah ping_pong_delay(wetLevel=0.1)`

- Play a sound via HTTP (note: must be CORS-compliant in most browsers)

  `@mick moo http://www.example.com/moo.mp3`

See [Tuna.js wiki](https://github.com/Theodeus/tuna/wiki) for a full list of effects and arguments.

## Development

```
docker build --build_arg rails_env=development -t mixlr/slackcast:latest .
docker run --rm -it -e RAILS_ENV=development mixlr/slackcast:latest
```

## Deployment

Via Heroku. Client pages should reload automatically after a deploy.

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
