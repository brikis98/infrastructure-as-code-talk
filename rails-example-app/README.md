# Rails Example App

This is a very simple Rails app used for demonstration purposes. The only changes from what you get after running
`rails new` are:

1. The root URL (`/`) returns the text "Hello, World v1".
2. The `/status` URL is a health check endpoint that returns a 200 OK. The ELB uses it to determine if the
   app is up and running.
3. There is a [Dockerfile](./Dockerfile) that packages this app as a Docker container and a
   [docker-compose.yml](./docker-compose.yml) file that offers a convenient way to run this app in dev mode.

## Quick start

To run the app:

1. Install [Docker](https://www.docker.com/). If you're on OS X, you may also want to install
   [docker-osx-dev](https://github.com/brikis98/docker-osx-dev), or the app will take a very long time to start up due
   to the slowness of VirtualBox mounted folders (see [A productive development environment with Docker on OS
   X](http://www.ybrikman.com/writing/2015/05/19/docker-osx-dev/)).
2. `cd rails-example-app`
3. `docker-compose-up`
4. Test the app by opening up [http://localhost:3000]() (or [http://dockerhost:3000]() if you're using docker-osx-dev).

The `docker-compose.yml` file mounts the current directory in the Docker image, so any changes you make to the Rails
app will automatically be reflected in the running app, so you can do iterative "make-a-change-and-refresh" development.

## Building your own Docker image

By default, `docker-compose.yml` is using the `brikis98/rails-example-app` Docker image. This is an image I pushed to
my [Docker Hub account](https://hub.docker.com/r/brikis98/rails-example-app/) that makes it easy for you to
try this repo quickly. However, since you don't have permissions to push new versions of the app to my account, to use
this code in the real world, you'll want to create your own Docker image as follows:

1. `cd rails-example-app`
2. `docker build -t your_username/rails-example-app .`
3. Set the `image` parameter in `docker-compose.yml` to `your_username/rails-example-app`.

(In the commands above, make sure to replace `your_username` with your actual [Docker Hub](https://hub.docker.com/)
username.)

## Building a Docker image for production

To build a Docker image for production, you'll need to:

1. Give the image a custom version number (AKA a Docker tag). You'll want to use a different version number for each
   image you push to production.
2. Push your Docker image to a Docker repo, such as [Docker Hub](https://hub.docker.com). Each production server will
   download the image from that repo.

Here are the steps:

1. `cd rails-example-app`
2. `docker build -t your_username/rails-example-app:version_number .`
3. `docker login`
4. `docker push your_username/rails-example-app:version_number`

(In the commands above, make sure to replace `your_username` with your actual [Docker Hub](https://hub.docker.com/)
username and `version_number` with a custom version number (e.g. `v1`, `v2`, etc).)
