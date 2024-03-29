# Project Purple Cow

## Overview

This solution is an AWS Lambda function which checks the expiration date of an SSL certificate for a given domain name and returns the number of days until expiration and whether the certificate is currently valid. The function also sends a message to an SNS topic if the certificate is invalid.

## Requirements

- AWS account
- IAM role with permissions to access SNS
- SNS topic created in your AWS account

## Operations

1. Deploy the Lambda function using the provided code
2. Configure an API Gateway to trigger the Lambda function
3. Send a GET request to the API Gateway endpoint with the domain name as a path parameter, for example:
   `https://<api_gateway_endpoint>/ssl/check/example.com`
4. The response will be a JSON object with the following properties:
   - `days_until_expiration`: The number of days until the SSL certificate expires.
   - `is_valid`: A boolean indicating whether the SSL certificate is currently valid.
   - `domain_name`: The domain name that was checked.
5. If the SSL certificate is invalid, a message will be sent to the SNS topic configured in the Lambda function.


## Test Cases

1. **Test with a valid certificate:**
   - **Input:** `https://<api_gateway_endpoint>/ssl/check/example.com`
   - **Output:** 
   ```
   {
     "days_until_expiration":365,
     "is_valid":true,
     "domain_name":"example.com"
   }
  ```

2. **Test with an invalid certificate:**
   - **Input:** `https://<api_gateway_endpoint>/ssl/check/expired.badssl.com`
   - **Output:** 
   ```
   {
     "days_until_expiration":0,
     "is_valid":false,
     "domain_name":"expired.badssl.com"
   }
   ```

   - **Expected SNS message:** 
  *The SSL certificate for expired.badssl.com has expired or is not valid.*

## Deployment

Deployment with terraform plans configure external resources like API Gateway, Lambda Function etc.

# REQUIREMENTS

* [Terraform](https://www.terraform.io)
* [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

# LINT

```console
$ cd terraform
$ terraform init
$ terraform plan
```

Note that Terraform modules have known bugs concerning validation logic. Linting with `terraform plan` can help to catch many errors early in development, perhaps 60% of errors. The remaining 40% will be caught at deployment time with `terraform apply`.

# PROVISION

```console
$ export AWS_ACCESS_KEY_ID="..."
$ export AWS_SECRET_ACCESS_KEY="..."
$ terraform apply [-auto-approve]
```
**Important!!!**

Update the code to the actual SNS Topic ARN in Lambda function and redeploy.

`topic_arn = "arn:aws:sns:<region>:<account_id>:ssl-updates"`

# Testing

In order to test create a test event from a template **API Gateway AWS Proxy**.

![Alt text](/images/test-event-creation.png?raw=true "Test Event Creation")

After selecting the template it will give to an interface to test the lambda function then you have to update the path in payload below.

From: `"/path/to/resource"`

To: `"/ssl/check/example.com"`

After update hit test button and check the response as given below:

![Alt text](/images/test-event-response.png?raw=true "Test Event Response")