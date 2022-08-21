ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION-alpine

ARG RAILS_USER
ENV RAILS_ROOT /app

ARG GEM_HOME

ENV LANG C.UTF-8

RUN apk add --update --no-cache \
  build-base \
  postgresql-dev \
  tzdata \
  sudo \
  git \
  && rm -rf /var/cache/apk/*

RUN adduser -D $RAILS_USER

RUN mkdir -p $RAILS_ROOT \
    chown $RAILS_USER $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

USER $RAILS_USER

COPY --chown=$RAILS_USER Gemfile Gemfile.lock ./

RUN echo "gem: --user-install --env-shebang --no-rdoc --no-ri" > /home/$RAILS_USER/.gemrc
ENV GEM_HOME $GEM_HOME
ENV PATH $GEM_HOME/bin:$PATH

RUN bundle install

COPY --chown=$RAILS_USER . .

EXPOSE 3000
