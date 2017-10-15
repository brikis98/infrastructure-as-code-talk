FROM rails:4.2.6
LABEL maintainer "Gruntwork <info@gruntwork.io>"

# Source code should be in the /usr/src/app folder
WORKDIR /usr/src/app

# Install dependencies in a cache-friendly way
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

# Now copy the rest of the source code
COPY . /usr/src/app
RUN chmod +x /usr/src/app/docker-entrypoint.sh

# Run the rails server by default
EXPOSE 3000
ENTRYPOINT ["bash","/usr/src/app/docker-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
