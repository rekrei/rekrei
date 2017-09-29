FROM rekrei/rekrei-base:2.3.1

MAINTAINER Matthew Vincent <matt@averails.com>

RUN mkdir /rekrei
WORKDIR /rekrei
COPY Gemfile Gemfile.lock /rekrei/
RUN gem install bundler && bundle install --jobs 20 --retry 5
# RUN bundle exec rake db:create
COPY . /rekrei
