#!/bin/bash

WORKSPACE_ID=ws-8LUWN83Xnq8atExm # aws_lambda

# update artifact's name

cat <<EOF> vars.json
{
  "data": {
    "id":"var-MVaQ54KcxjEU1p9u",
    "attributes": {
      "key":"artifact",
      "value":"${GITHUB_SHA}.zip",
      "description": "Dynamically generated artifact name",
      "category":"terraform",
      "hcl": false,
      "sensitive": false
    },
    "type":"vars"
  }
}
EOF

curl \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data @vars.json \
  https://app.terraform.io/api/v2/vars/var-MVaQ54KcxjEU1p9u

# Terraform code
UPLOAD_FILE_NAME="./content_$(date +'%Y%m%d%H%M%S').zip"

echo ${UPLOAD_FILE_NAME}

tar cvfz ${UPLOAD_FILE_NAME} lambda.tf

# Create config-version
echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json

UPLOAD_URL=($(curl \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @create_config_version.json \
  https://app.terraform.io/api/v2/workspaces/${WORKSPACE_ID}/configuration-versions \
  | jq -r '.data.attributes."upload-url"'))

echo  ${UPLOAD_URL}

# Upload terraform conig to TFC
curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL

rm ${UPLOAD_FILE_NAME}
rm ./vars.json
rm ./create_config_version.json
