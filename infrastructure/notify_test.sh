#!/usr/bin/env bash
set -euo pipefail

# =========
# VARIABLES
# =========
TOPIC_ARN="arn:aws:sns:eu-central-1:841162699538:grocerymate-new-products"
LAMBDA_NAME="grocerymate-new-product-notifier"
EMAIL="adryland79@gmail.com"
BUCKET="grocerymate-avatarsadry"
REGION="eu-central-1"
PROFILE="default"

echo "Usando:"
echo "  TOPIC_ARN   = $TOPIC_ARN"
echo "  LAMBDA_NAME = $LAMBDA_NAME"
echo "  EMAIL       = $EMAIL"
echo "  BUCKET      = $BUCKET"
echo "  REGION      = $REGION"
echo "  PROFILE     = $PROFILE"
echo

# 4) Suscribir email al Topic SNS
echo "Suscribiendo $EMAIL al topic SNS..."
aws sns subscribe \
  --topic-arn "$TOPIC_ARN" \
  --protocol email \
  --notification-endpoint "$EMAIL" \
  --region "$REGION" \
  --profile "$PROFILE"

echo "👉 Revisa tu correo y CONFIRMA la suscripción (puede tardar 1-2 min; revisa SPAM)."
echo "Estado de suscripciones:"
aws sns list-subscriptions-by-topic \
  --topic-arn "$TOPIC_ARN" \
  --region "$REGION" \
  --profile "$PROFILE" || true

# 5-A) Publicación de prueba DIRECTO al Topic (más rápido de verificar tras confirmar)
echo
echo "Publicando mensaje de PRUEBA directo al Topic..."
aws sns publish \
  --topic-arn "$TOPIC_ARN" \
  --subject "GroceryMate: New product" \
  --message "New product: Organic Avocado (SKU: AVO-001) - Price: 3.49" \
  --region "$REGION" \
  --profile "$PROFILE"

# 5-B) (Opcional) Invocar Lambda que publica en SNS
echo
echo "Invocando Lambda (opcional)..."
aws lambda invoke \
  --function-name "$LAMBDA_NAME" \
  --payload '{"product_name":"Organic Avocado","sku":"AVO-001","price":3.49}' \
  --cli-binary-format raw-in-base64-out \
  /tmp/lambda_test_response.json \
  --region "$REGION" \
  --profile "$PROFILE"
echo "Respuesta Lambda:"
cat /tmp/lambda_test_response.json || true

# 6) Subir avatar por defecto a S3 (si existe localmente)
echo
LOCAL_AVATAR="$HOME/AWS_grocery/backend/avatar/user_default.png"
if [ -f "$LOCAL_AVATAR" ]; then
  echo "Subiendo avatar por defecto a S3..."
  aws s3 cp "$LOCAL_AVATAR" "s3://${BUCKET}/avatars/user_default.png" \
    --region "$REGION" \
    --profile "$PROFILE"
else
  echo "⚠ No se encontró el archivo local: $LOCAL_AVATAR"
  echo "   Ajusta la ruta si es necesario."
fi

echo "Listando objetos en s3://${BUCKET}/avatars/ ..."
aws s3 ls "s3://${BUCKET}/avatars/" \
  --region "$REGION" \
  --profile "$PROFILE" || true

echo
echo "Listo. Si confirmaste la suscripción, deberías recibir el correo del publish."
