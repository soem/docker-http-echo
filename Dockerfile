FROM ruby:2.5-alpine

ENV HTTP_PORT=80

RUN \
    gem install sinatra --no-ri --no-rdoc

COPY http-echo.rb /opt/http-echo.rb

EXPOSE 80
CMD \
    ruby /opt/http-echo.rb
