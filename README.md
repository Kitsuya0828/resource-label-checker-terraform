# resource-label-checker-terraform

A Terraform repository for [Kitsuya0828/resource\-label\-checker](https://github.com/Kitsuya0828/resource-label-checker).

Ironically, despite the tool being designed to check for the presence of resource labels, deployed resources are not labelled, so the results include resources that have just been created.

## Google Cloud
![gcp_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/2ded8b05-8d82-4af2-8729-1af902fe590c)

Directory `gcp/resource-label-checker-shared/` declares an Artifact Registry for pushing Docker images from GitHub Actions and pulling Docker images from Cloud Run. Directory `gcp/resource-label-checker/` declares Cloud Run to run the resouce-label-checker and Cloud Scheduler to trigger it.

## AWS
#### `aws/resource-label-checker-fargate`

![aws_fargate_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/4c362fb9-e6ec-430b-b320-8060b77d2818)

Use EventBridge Scheduler to run ECS Tasks on a regular basis.
When pulling Docker images from the ECR, VPC endpoints are used to reduce NAT Gateway communication costs

#### `aws/resource-label-checker-lambda`
![aws_lambda_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/4ccbe92c-654d-41cc-bb8f-8c406434a948)

Create an EventBridge Rule to execute a Lambda function periodically.
The timeout is 15 minutes, so be careful not to exceed it.
