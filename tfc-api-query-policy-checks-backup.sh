#!/bin/bash
set -aex

#Use Team Token from TFE/TFC
export TFC_ORG_NAME=aharness-org

get_workspaces_result=$(curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$TFC_ORG_NAME/workspaces)

#below examples works
#workspace_id=$(echo $get_workspaces_result | jq  -r '.data[].id') 
workspace_id=$(echo $get_workspaces_result | jq  -c '.data[].id') 

#Loop through workspaces that token has access to
for row in $(echo $workspace_id); do
  _jq() {
    echo ${row} | jq -r ${1}
  }
  echo $(_jq )
  curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/workspaces/$(_jq)/runs | jq
done




#curl \
#  --header "Authorization: Bearer $TOKEN" \
#  https://app.terraform.io/api/v2/runs/run-CZcmD7eagjhyXavN/policy-checks

#curl \
#  --header "Authorization: Bearer $TOKEN" \
#  --header "Content-Type: application/vnd.api+json" \
#  https://app.terraform.io/api/v2/organizations/$TFC_ORG_NAME/workspaces
