FROM gliderlabs/alpine:3.4
MAINTAINER Gruntwork <info@gruntwork.io>

# Install Sinatra
RUN apk --update upgrade &&\
    apk --no-cache add curl ca-certificates &&\
    apk --no-cache add ruby ruby-dev &&\
    gem install sinatra --no-ri --no-rdoc

# Source code should be in the /usr/src/app folder
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app

# Run the rails server by default
EXPOSE 4567
CMD ["ruby", "app.rb"]