FROM rekrei/base:290a04173f9c1718543895404980eb5dc1fc318c

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
