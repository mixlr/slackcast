FROM ruby:2.5.0

ENV DEBIAN_FRONTEND=noninteractive

# yarn
RUN curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - > /dev/null

RUN apt-get -qq update \
  && apt-get -yqq upgrade -o=Dpkg::Use-Pty=0 \
  && apt-get -yqq install -o=Dpkg::Use-Pty=0 --no-install-recommends \
    build-essential \
    nodejs \
    yarn \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

ENV APP_ROOT=/srv/app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
ADD .ruby-version Gemfile Gemfile.lock $APP_ROOT/
RUN bundle install -j $(nproc)
ADD . $APP_ROOT

ENTRYPOINT ["bundle", "exec"]
CMD ["foreman", "start"]
