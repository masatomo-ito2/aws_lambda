#!/bin/bash

# re-packaging and upload
zip example.zip main.js
aws s3 cp example.zip s3://hashicorp-japan/masa/terraform_serverless/example.zip 

# force recreate the resource
terraform taint aws_lambda_function.example
terraform taint aws_lambda_permission.apigw

# apply
terraform apply -auto-approve
