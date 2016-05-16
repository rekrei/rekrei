FROM rekrei/rekrei-base:latest

MAINTAINER Matthew Vincent <matt@averails.com>

RUN mkdir /rekrei
WORKDIR /rekrei
COPY Gemfile /rekrei/Gemfile
COPY Gemfile.lock /rekrei/Gemfile.lock
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test
COPY . /rekrei
ENV RAILS_ENV production
ENV RACK_ENV production
RUN bundle exec rake assets:precompile
EXPOSE 80
EXPOSE 443
CMD ["bundle","exec","puma","-C","config/puma.rb"]
