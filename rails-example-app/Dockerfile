FROM rails:4.2.6
MAINTAINER Yevgeniy Brikman <jim@ybrikman.com>

# Source code should be in the /usr/src/app folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install dependencies in a cache-friendly way
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

# Now copy the rest of the source code
COPY . /usr/src/app

# Run the rails server by default
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]