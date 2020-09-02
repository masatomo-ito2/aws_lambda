#!/bin/bash

# $B$3$N(BID$B$r(BTFC$B>e$N(BWorkspace$B$N$b$N$K=q$-49$($F$/$@$5$$(B
WORKSPACE_ID=ws-xxxxxxxxxxxxxxxx 

# Deploy$B$9$k%Q%C%1!<%8$rJQ?t$GDj5A$7$^$9!#(B
# $BJQ?t$N(BID$B$O(BTFC$B>e$GDj5A$9$k(BVariable$B$N(BID$B$K=q$-49$($F$/$@$5$$!#(B

cat <<EOF> vars.json
{
  "data": {
    "id":"var-xxxxxxxxxxxxxxxx", 
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

# Terraform code$B$r%m!<%I$7$^$9!#(B
UPLOAD_FILE_NAME="./content_$(date +'%Y%m%d%H%M%S').zip"

echo ${UPLOAD_FILE_NAME}

tar cvfz ${UPLOAD_FILE_NAME} lambda.tf

# Terraform code$B$r%"%C%W%m!<%I$9$k(BURL$B$r<hF@$7$^$9!#(B
echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json

UPLOAD_URL=($(curl \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @create_config_version.json \
  https://app.terraform.io/api/v2/workspaces/${WORKSPACE_ID}/configuration-versions \
  | jq -r '.data.attributes."upload-url"'))

echo  ${UPLOAD_URL}

# Terraform code$B$r%"%C%W%m!<%I$7$F(BRun$B$N%H%j%,$r$+$1$^$9!#(B
curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL

# $B%/%j!<%s%"%C%W(B
rm ${UPLOAD_FILE_NAME}
rm ./vars.json
rm ./create_config_version.json
