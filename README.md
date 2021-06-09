# testEnvironment

# Several steps to create infrastructure in AWS:
## 1) Create Free Tier account in AWS and create user with privileges in IAM.
## 2) Install awscli and configure it with command 'aws configure', pass the credentials which you gain when create a user IAM.
## 3) Install terraform module.
## 4) Create a bucket on s3 for store your terraformstatefile with command 'aws s3api create-bucket --bucket <yourBucketName> --create-bucket-configuration LocationConstraint=eu-central-1'.
## 5) Create infrastructure
