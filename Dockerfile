FROM ruby:2.3.1

MAINTAINER Matthew Vincent <matt@averails.com>

RUN apt-get update && apt-get -y install imagemagick libmagickcore-dev libmagickwand-dev libpq-dev nodejs
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir /rekrei
WORKDIR /rekrei
COPY Gemfile /rekrei/Gemfile
COPY Gemfile.lock /rekrei/Gemfile.lock
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test
COPY . /rekrei
ENV RAILS_ENV production
ENV RACK_ENV production
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]
