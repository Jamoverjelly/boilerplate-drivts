FROM ruby:3.1.0 AS base

LABEL maintainer="jstrausb86@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs yarn libsndfile1 libsndfile1-dev sox nano

RUN gem install sassc -v 2.4.0
RUN gem install mysql2 -v 0.5.2
RUN gem install bootsnap -v 1.9.1
RUN gem install bundler:2.3.14
WORKDIR /usr/src/app
COPY package.json /usr/src/app
RUN npm install
COPY Gemfile* /usr/src/app/
RUN bundle install
COPY . /usr/src/app/
RUN bundle lock --add-platform arm64-darwin-21
RUN bundle lock --add-platform x86_64-linux
# COPY docker.ldci.config /root/.ldci.config

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
