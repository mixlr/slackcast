FROM ruby:2.5.0-alpine AS build-env

ARG rails_root=/src/app
ARG rails_env=production
ARG build_packages="build-base curl-dev git"
ARG dev_packages="yaml-dev zlib-dev nodejs yarn"
ARG ruby_packages="tzdata"

ENV RAILS_ENV=${rails_env}
ENV NODE_ENV=${rails_env}
ENV BUNDLE_APP_CONFIG="$rails_root/.bundle"

WORKDIR $rails_root

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $build_packages $dev_packages $ruby_packages

# install rubygem
COPY Gemfile Gemfile.lock $rails_root/
RUN bundle config --global frozen 1 \
    && bundle install -j$(nproc) --retry 3 --path=vendor/bundle \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/2.5.0/cache/*.gem \
    && find vendor/bundle/ruby/2.5.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.5.0/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
# RUN bin/rails webpacker:compile
RUN bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec

############### Build step done ###############

FROM ruby:2.5.0-alpine
ARG rails_root=/src/app
ARG packages="tzdata nodejs"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$rails_root/.bundle"
ENV RAILS_ROOT=${rails_root}

WORKDIR $rails_root

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $packages

COPY --from=build-env $rails_root $rails_root
EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["foreman", "start"]
