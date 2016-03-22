# Infrastructure as Code Talk

This repo contains the sample code for the talk [Infrastructure-as-code in the real world: running microservices on AWS
with Docker, ECS, and Terraform](http://www.incontrodevops.it/sessions/infrastructure-as-code-in-the-real-world-running-microservices-on-aws-with-docker-ecs-and-terraform/).
It consists of:

1. A ["Hello, World" Rails app](./rails-example-app).
2. A [Dockerfile](./rails-example-app/Dockerfile) to package the Rails app as a Docker container.
3. [Terraform templates](./terraform-templates) to deploy the Docker container on Amazon's [EC2 Container Service
   (ECS)](https://aws.amazon.com/ecs/) with an [Elastic Load Balancer (ELB)](https://aws.amazon.com/elasticloadbalancing/)
   in front of it.

**Note**: This repo is for demonstration purposes only and should NOT be used to run anything important. For
production-ready version of these templates, and many other types of infrastructure, check out
[Atomic Squirrel](http://atomic-squirrel.net/).

## How to run the Rails app locally

To run the app on your local dev box, see the [rails-example-app README](./rails-example-app).

## How to deploy the Rails app to AWS

To deploy the app to your AWS account, see the [terraform-templates README](./terraform-templates).

## How to deploy a new version of the Rails app

Every time you want to deploy a new version of your app, you need to:

1. Build a new version of the Docker image by following the "Building a Docker image for production" instructions in the
   [rails-example-app README](./rails-example-app). Set the `app_image` and `app_version` variables in
   `terraform.tfvars` to the image name and version, respectively, of the new Docker image you just created.
2. Deploy the new Docker image with Terraform by following the "Deploying changes" instructions in the
   [terraform-templates README](./terraform-templates).
