# Terraform configurations

This folder contains [Terraform](https://www.terraform.io/) configurations to deploy [Docker](https://www.docker.com/)
images of the [rails-frontend](../rails-frontend) and [sinatra-backend](../sinatra-backend) example microservices using
Amazon's [EC2 Container Service (ECS)](https://aws.amazon.com/ecs/).

![Architecture](/_docs/architecture.png)





## Quick start

**NOTE**: Following these instructions will deploy code into your AWS account, including several `t2.micro` instances 
and two ELBs. All of this qualifies for the [AWS Free Tier](https://aws.amazon.com/free/), but if you've already used 
up your credits, running this code may cost you money.


### Initial setup

1. Sign up for an [AWS account](https://aws.amazon.com/). If this is your first time using AWS Marketplace, head over
   to the [ECS AMI Marketplace page](https://aws.amazon.com/marketplace/pp/B00U6QTYI2) and accept the terms of service.
1. Install [Terraform](https://www.terraform.io/).
1. `cd terraform-configurations`
1. Open `vars.tf`, set the environment variables specified at the top of the file, and feel free to tweak any of the
   other variables to your liking.
   

### Deploying

1. Configure your AWS credentials as [environment 
   variables](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment):
   
    ```
    export AWS_ACCESS_KEY_ID=...
    export AWS_SECRET_ACCESS_KEY=...
    ```
   
1. `terraform init`

1. `terraform plan`

1. If the plan looks good, run `terraform apply` to deploy the code into your AWS account.

1. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

After `terraform apply` completes, it will output the URLs of the ELBs of the rails-frontend and sinatra-backend apps.


### Deploying new versions

Every time you want to deploy a new version of one of the microservices, you need to:

1. Build a new version of the Docker image for that microservice by following the "How to use your own Docker images"
   instructions in the [root README](../README.md) (or better yet, create a CI job that builds a new image after every
   commit). Set the `rails_frontend_image` and `rails_frontend_version` or `sinatra_backend_image` and
   `sinatra_backend_version` variables in `terraform.tfvars` to the image name and version of the new Docker image you
   just created.
1. Deploy the new Docker image with Terraform by following the "Deploying" instructions above.
