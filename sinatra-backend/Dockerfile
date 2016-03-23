FROM gliderlabs/alpine:3.3
MAINTAINER Yevgeniy Brikman <jim@ybrikman.com>

# Source code should be in the /usr/src/app folder
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app

# Install Sinatra
RUN apk --no-cache add ruby ruby-dev
RUN gem install sinatra --no-ri --no-rdoc

# Run the rails server by default
EXPOSE 4567
CMD ["ruby", "app.rb"]