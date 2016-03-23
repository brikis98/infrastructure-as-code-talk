# sinatra-backend

This is a simple [Sinatra app](http://www.sinatrarb.com/) used as a demonstration of a backend microservice. The app
contains just two endpoints:

1. The root URL (`/`) returns the text "Hello, World".
2. The `/health` URL is a health check endpoint that returns a 200 OK. The ELB uses this endpoint to determine if the
   app is up and running.

This app contains a [Dockerfile](./Dockerfile) that packages the app as a Docker container.

## How to run this app

See the [root README file](../README.md) for instructions on how to run this app.

