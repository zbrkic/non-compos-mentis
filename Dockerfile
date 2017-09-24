FROM jekyll/jekyll:3.5

WORKDIR $JEKYLL_DATA_DIR
COPY site .

RUN bundle update

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--no-watch", "-d", "public"]
