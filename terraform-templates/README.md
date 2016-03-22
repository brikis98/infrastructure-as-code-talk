# Terraform templates

This folder contains [Terraform](https://www.terraform.io/) templates to deploy a [Docker image](https://www.docker.com/)
of the [rails-example-app](../rails-example-app) using Amazon's [EC2 Container Service (ECS)](https://aws.amazon.com/ecs/).

## Quick start

**NOTE**: Following these instructions will deploy code into your AWS account, including four `t2.micro` instances and
an ELB. All of this qualifies for the [AWS Free Tier](https://aws.amazon.com/free/), but if you've already used up your
credits, running this code may cost you money.

### Initial setup

1. Sign up for an [AWS account](https://aws.amazon.com/). If this is your first time using AWS Marketplace, head over
   to the [ECS AMI Marketplace page](https://aws.amazon.com/marketplace/ordering?productId=4ce33fd9-63ff-4f35-8d3a-939b641f1931)
   and accept the terms of service.
2. Install [Terraform](https://www.terraform.io/).
3. `cd terraform`
4. Rename `terraform.tfvars.sample` to `terraform.tfvars` and follow the instructions in the file to set up your
   variables.

### Deploying changes

1. `terraform plan`
2. If the plan looks good, run `terraform apply` to deploy the code into your AWS account.
3. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

After `terraform apply` completes, it will output the URL of the ELB. Visit that URL and you should see the text
"Hello, World".