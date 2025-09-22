import os
import json
import boto3

ses = boto3.client("ses")

FROM_EMAIL = os.environ.get("FROM_EMAIL")   # remitente verificado en SES
TO_EMAIL   = os.environ.get("TO_EMAIL")     # destinatario (en sandbox: verificado)
CF_DOMAIN  = os.environ.get("CF_DOMAIN")    # p.ej. dxxxx.cloudfront.net

def lambda_handler(event, context):
    for record in event.get("Records", []):
        msg_str = record["Sns"]["Message"]
        try:
            msg = json.loads(msg_str)
        except Exception:
            msg = {"type": "UNKNOWN", "raw": msg_str}

        product = msg.get("product", {})
        name  = product.get("product_name", "New product")
        price = product.get("price", "")
        sku   = product.get("sku", "")
        # nombre de archivo en S3/CloudFront, ej: products/avocado.png
        image_key = product.get("image_key", "products/placeholder.png")

        # URL pública de la imagen por CloudFront (o S3 si tienes bucket público)
        image_url = f"https://{CF_DOMAIN}/{image_key}"

        subject = f"New product available: {name}"
        html = f"""
        <html>
          <body style="font-family: Arial, sans-serif;">
            <h2>New Product Available</h2>
            <p><strong>Name:</strong> {name}</p>
            <p><strong>SKU:</strong> {sku}</p>
            <p><strong>Price:</strong> {price}</p>
            <p><img src="{image_url}" alt="{name}" style="max-width:480px"/></p>
            <p><a href="{image_url}">Open image</a></p>
          </body>
        </html>
        """
        text = f"New product: {name} (SKU: {sku}) - Price: {price}\nImage: {image_url}"

        ses.send_email(
            Source=FROM_EMAIL,
            Destination={"ToAddresses": [TO_EMAIL]},
            Message={
                "Subject": {"Data": subject, "Charset": "UTF-8"},
                "Body": {
                    "Text": {"Data": text, "Charset": "UTF-8"},
                    "Html": {"Data": html, "Charset": "UTF-8"},
                },
            },
        )

    return {"statusCode": 200, "body": json.dumps({"ok": True})}
