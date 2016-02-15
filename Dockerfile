FROM ruby:2.3.0-alpine

MAINTAINER Matthew Vincent <matt@averails.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev imagemagick libpq-dev libxml2-dev libxslt1-dev nodejs
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /rekrei
WORKDIR /rekrei
COPY Gemfile /rekrei/Gemfile
COPY Gemfile.lock /rekrei/Gemfile.lock
RUN bundle install
COPY . /rekrei
