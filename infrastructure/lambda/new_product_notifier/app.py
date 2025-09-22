import os
import json
import boto3

sns = boto3.client("sns")
TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    """
    Expected event:
    {
      "product_id": "123",
      "name": "Banana",
      "price": 1.99
    }
    """
    message = {"type": "NEW_PRODUCT", "product": event}
    sns.publish(
        TopicArn=TOPIC_ARN,
        Subject="New product available",
        Message=json.dumps(message)
    )
    return {"status": "ok"}
