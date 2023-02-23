FROM rekrei/base:0ec6679c4de859972309e25f95d0b44f1886768e

LABEL org.opencontainers.image.authors="matthew@rekrei.org"

ENV BUNDLE_GEMFILE=/rekrei/Gemfile \
    BUNDLE_JOBS=20 \
    BUNDLE_PATH=/bundler \
    GEM_HOME=/bundler

RUN mkdir -p /rekrei
WORKDIR /rekrei
COPY Gemfile* /rekrei/
RUN gem install bundler -v=1.16.0 && bundle install 

COPY . /rekrei
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]
