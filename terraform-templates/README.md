# Terraform templates

This folder contains [Terraform](https://www.terraform.io/) templates to deploy [Docker](https://www.docker.com/)
images of the [rails-frontend](../rails-frontend) and [sinatra-backend](../sinatra-backend) example microservices using
Amazon's [EC2 Container Service (ECS)](https://aws.amazon.com/ecs/).

## Quick start

**NOTE**: Following these instructions will deploy code into your AWS account, including four `t2.micro` instances and
two ELBs. All of this qualifies for the [AWS Free Tier](https://aws.amazon.com/free/), but if you've already used up
your credits, running this code may cost you money.

### Initial setup

1. Sign up for an [AWS account](https://aws.amazon.com/). If this is your first time using AWS Marketplace, head over
   to the [ECS AMI Marketplace page](https://aws.amazon.com/marketplace/ordering?productId=4ce33fd9-63ff-4f35-8d3a-939b641f1931)
   and accept the terms of service.
2. Install [Terraform](https://www.terraform.io/).
3. `cd terraform-templates`
4. Rename `terraform.tfvars.sample` to `terraform.tfvars` and follow the instructions in the file to set up your
   variables.

### Deploying

1. `terraform plan`
2. If the plan looks good, run `terraform apply` to deploy the code into your AWS account.
3. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

After `terraform apply` completes, it will output the URLs of the ELBs of the rails-frontend and sinatra-backend apps.

### Deploying new versions

Every time you want to deploy a new version of one of the microservices, you need to:

1. Build a new version of the Docker image for that microservice by following the "How to use your own Docker images"
   instructions in the [root README](../README.md) (or better yet, create a CI job that builds a new image after every
   commit). Set the `rails_frontend_image` and `rails_frontend_version` or `sinatra_backend_image` and
   `sinatra_backend_version` variables in `terraform.tfvars` to the image name and version of the new Docker image you
   just created.
2. Deploy the new Docker image with Terraform by following the "Deploying" instructions above.
