import json
import ssl
import socket
import boto3
from datetime import datetime


def check_ssl_expiration(domain_name):
    try:
        ssl_date_fmt = r"%b %d %H:%M:%S %Y %Z"
        context = ssl.create_default_context()
        conn = context.wrap_socket(
            socket.socket(socket.AF_INET),
            server_hostname=domain_name,
        )
        conn.settimeout(3.0)
        conn.connect((domain_name, 443))
        ssl_info = conn.getpeercert()
        expires = datetime.strptime(ssl_info["notAfter"], ssl_date_fmt)
        expires = expires.replace(microsecond=0)
        days_until_expiration = (expires - datetime.now()).days
        is_valid = True
    except Exception:
        days_until_expiration = 0
        is_valid = False
    return {
        "days_until_expiration": days_until_expiration,
        "is_valid": is_valid,
        "domain_name": domain_name,
    }


def lambda_handler(event, context):
    domain_name = event["pathParameters"]["proxy"]
    result = check_ssl_expiration(domain_name)
    if not result["is_valid"]:
        # publish message to SNS topic
        sns = boto3.client("sns")
        # SNS topic ARN
        topic_arn = "arn:aws:sns:<region>:<account_id>:ssl-updates"
        message = f"The SSL certificate for {domain_name} has expired or is not valid."
        sns.publish(TopicArn=topic_arn, Message=message)
    return {"statusCode": 200, "body": json.dumps(result)}
