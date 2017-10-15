FROM alpine:3.6
LABEL maintainer "Gruntwork <info@gruntwork.io>"

# Install Sinatra
RUN apk --update upgrade && \
    apk --no-cache add curl ca-certificates && \
    apk --no-cache add ruby ruby-dev && \
    gem install sinatra --no-ri --no-rdoc

# Source code should be in the /usr/src/app folder
WORKDIR /usr/src/app
COPY . /usr/src/app


# Run the rails server by default
EXPOSE 4567
CMD ["ruby", "app.rb"]
