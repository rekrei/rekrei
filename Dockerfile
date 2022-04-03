FROM rekrei/base:58270a24e586fe3107062135564ec5ea81638a91

AUTHOR Matthew Vincent <matthew@rekrei.org>

ENV BUNDLE_GEMFILE=/rekrei/Gemfile \
    BUNDLE_JOBS=20 \
    BUNDLE_PATH=/bundler \
    GEM_HOME=/bundler

RUN mkdir /rekrei
WORKDIR /rekrei
COPY Gemfile* /rekrei/
RUN gem install bundler && bundle install

COPY . /rekrei
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]
