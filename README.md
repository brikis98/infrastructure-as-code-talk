# Infrastructure as Code Talk

This repo contains the sample code for the talk [Infrastructure-as-code in the real world: running microservices on AWS
with Docker, ECS, and Terraform](http://www.incontrodevops.it/sessions/infrastructure-as-code-in-the-real-world-running-microservices-on-aws-with-docker-ecs-and-terraform/).
It consists of:

1. A ["Hello, World" Rails app](./rails-example-app).
2. A [Dockerfile](./rails-example-app/Dockerfile) to package the Rails app as a Docker container.
3. [Terraform templates](./terraform) to deploy the Docker container on Amazon's [EC2 Container Service
   (ECS)](https://aws.amazon.com/ecs/) with an [Elastic Load Balancer (ELB)](https://aws.amazon.com/elasticloadbalancing/)
   in front of it.

**Note**: This repo is for demonstration purposes only and should NOT be used to run anything important. For
production-ready version of these templates, and many other types of infrastructure, check out
[Atomic Squirrel](http://atomic-squirrel.net/).

## How to run the Rails app locally

To run the app on your local dev box:

1. Install [Docker](https://www.docker.com/). If you're on OS X, you may also want to install
   [docker-osx-dev](https://github.com/brikis98/docker-osx-dev).
2. `cd rails-example-app`
3. `docker-compose-up`
4. Test the app by opening up [http://localhost:3000]() (or [http://dockerhost:3000]() if you're using docker-osx-dev).

## How to deploy the Rails app to AWS

**NOTE**: Following these instructions will deploy code into your AWS account, including four `t2.micro` instances and
an ELB. All of this qualifies for the [AWS Free Tier](https://aws.amazon.com/free/), but if you've already used up your
credits, running this code may cost you money.

To deploy the Rails app to your AWS account:

1. Sign up for an [AWS account](https://aws.amazon.com/). If this is your first time using AWS Marketplace, head over
   to the [ECS AMI Marketplace page](https://aws.amazon.com/marketplace/ordering?productId=4ce33fd9-63ff-4f35-8d3a-939b641f1931)
   and accept the terms of service.
2. Install [Terraform](https://www.terraform.io/).
3. `cd terraform`
4. Rename `terraform.tfvars.sample` to `terraform.tfvars` and follow the instructions in the file to set up your
   variables.
5. `terraform plan`
6. If the plan looks good, run `terraform apply` to deploy the code into your AWS account.
7. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

After `terraform apply` completes, it will output the URL of the ELB. Visit that URL and you should see the text
"Hello, World".

## How to create your own Docker image

The default value of the `app_image` variable in `terraform.tfvars` is `brikis98/rails-example-app`. This is an image
I pushed to my [Docker Hub account](https://hub.docker.com/r/brikis98/rails-example-app/) that makes it easy for you to
try this repo quickly. However, since you don't have permissions to push new versions of the app to my account, to use
this code in the real world, you'll want to create your own Docker image as follows:

1. `cd rails-example-app`
2. `docker build -t your_username/rails-example-app .`
   * Fill in `your_username` with your [Docker Hub](https://hub.docker.com/) username)
3. `docker login`
4. `docker push your_username/rails-example-app`
5. Set the `app_image` variable in `terraform.tfvars` to `your_username/rails-example-app`.

## How to deploy a new version of the Rails app

Every time you want to deploy a new version of your app, you need to:

1. Build a new version of your Docker image.
2. Deploy the new Docker image with Terraform.

### Build a new version of your Docker image

To build a new version of the Docker image:

1. `cd rails-example-app`
2. `docker build -t your_username/rails-example-app:v1 .` (The `v1` is a [Docker
   tag](https://docs.docker.com/mac/step_six/). You should set it to a new value each time you build the image.)
3. `docker login`
4. `docker push your_username/rails-example-app:v1`

Note: It's a good idea to set up a CI job to do these steps for you automatically after every commit.

### Deploy the new DOcker image with Terraform

To deploy this new version:

1. `cd terraform`
2. Set the `app_version` variable in `terraform.tfvars` to `v1` (or whatever version number you're up to).
3. `terraform plan`
4. If the plan looks good, run `terraform apply` to deploy the new version into your AWS account.
5. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

