ARG ruby_version=2.7.3
FROM ruby:$ruby_version-alpine AS build-env

# install packages
ARG build_packages="build-base curl git"
ARG dev_packages="yaml-dev zlib-dev nodejs yarn"
ARG ruby_packages="tzdata"
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $build_packages $dev_packages $ruby_packages

ARG rails_root=/src/app
ARG rails_env=production
ENV RAILS_ROOT=${rails_root}
ENV RAILS_ENV=${rails_env}
ENV NODE_ENV=${rails_env}

WORKDIR $rails_root
COPY .ruby-version Gemfile Gemfile.lock $rails_root/
RUN bundle config --global frozen 1 \
  && bundle install -j$(nproc) --retry 3

COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
# RUN bin/rails webpacker:compile
# RUN bin/rails assets:precompile

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["foreman", "start"]
