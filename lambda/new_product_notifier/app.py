import json
import os
import boto3

ses = boto3.client("ses")
TEMPLATE = os.environ.get("SES_TEMPLATE_NAME", "GrocerymateNewProduct")
SENDER   = os.environ.get("SES_SENDER_EMAIL")
RECIP    = os.environ.get("SES_RECIPIENT_EMAIL")
IMG_BASE = os.environ.get("IMAGE_BASE_URL", "")

def _extract_message(event):
    if isinstance(event, dict) and "Records" in event:
        try:
            msg = event["Records"][0]["Sns"]["Message"]
            return json.loads(msg) if isinstance(msg, str) else msg
        except Exception:
            return event
    return event

def lambda_handler(event, context):
    message = _extract_message(event)
    product = (message or {}).get("product", {})
    product_name = str(product.get("product_name", "New product"))
    sku          = str(product.get("sku", "SKU-NA"))
    price        = product.get("price")
    image_key    = product.get("image_key", "")

    image_url    = f"{IMG_BASE}/{image_key}" if (IMG_BASE and image_key) else IMG_BASE
    product_link = IMG_BASE if IMG_BASE else "https://example.com"

    template_data = {
        "product_name": product_name,
        "sku": sku,
        "price": f"{price:.2f}" if isinstance(price, (int, float)) else str(price or "—"),
        "image_url": image_url or "https://via.placeholder.com/400x300?text=GroceryMate",
        "product_link": product_link,
    }

    resp = ses.send_templated_email(
        Source=SENDER,
        Destination={"ToAddresses": [RECIP]},
        Template=TEMPLATE,
        TemplateData=json.dumps(template_data)
    )

    return {
        "statusCode": 200,
        "body": json.dumps({"ok": True, "ses_message_id": resp.get("MessageId")})
    }
