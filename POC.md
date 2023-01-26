# Project Purple Cow

Project Purple Cow’s main objective is to check the validity of customer’s domain’s SSL certificates.
Project purple cow is meant to be a generic solution that will be operational for multiple domains
instead of one specific domain.

Project purple cow receives a hostname as input and returns 3 values in JSON format. The return values
are as follows:
 - days_until_expiration 
 - is_valid 
 - domain_name

The following resources are viable for this project:
- Cloud Provider (AWS)
- Infrastructure As Code (Terraform)
- AWS Lambda function and test cases (Python)

It can take up to 2 hours.
