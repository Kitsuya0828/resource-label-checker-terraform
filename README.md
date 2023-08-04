# resource-label-checker-terraform

A Terraform repository for [Kitsuya0828/resource\-label\-checker](https://github.com/Kitsuya0828/resource-label-checker).

Ironically, despite the tool being designed to check for the presence of resource labels, deployed resources are not labelled, so the results include resources that have just been created.

## Google Cloud
![gcp_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/b724f6a4-579b-4c83-942d-ed2da68f1414)

Directory `gcp/resource-label-checker-shared/` declares an Artifact Registry for pushing Docker images from GitHub Actions and pulling Docker images from Cloud Run. Directory `gcp/resource-label-checker/` declares Cloud Run to run the resouce-label-checker and Cloud Scheduler to trigger it.

## AWS
#### `aws/resource-label-checker-fargate`

![aws_fargate_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/a6fa66d4-d42b-43dc-8e92-2dbfcc80ccdb)

Use EventBridge Scheduler to run ECS Tasks on a regular basis.
When pulling Docker images from the ECR, VPC endpoints are used to reduce NAT Gateway communication costs

#### `aws/resource-label-checker-lambda`
![aws_lambda_architecture](https://github.com/Kitsuya0828/resource-label-checker-terraform/assets/60843722/813501a8-8921-4e88-8812-b849f534cac8)

Create an EventBridge Rule to execute a Lambda function periodically.
The timeout is 15 minutes, so be careful not to exceed it.