#!/usr/bin/env bash

# Deploy crawler
cd crawler/env
export TF_VAR_proxy_pem="$(cat proxy.pem)"

terraform plan -out dev.tfplan && terraform apply dev.tfplan
if [[ $? -ne 0 ]];
then
    echo 'Terraform deploy failed!'
    exit 1
fi
terraform output -json | jq -r 'keys[] as $k | "\($k)=\(.[$k].value)"' > .env

# Copy database info for deploying reader
cd ../../
mv crawler/env/.env reader/

# Deploy reader
cd reader
sls deploy
if [[ $? -ne 0 ]];
then
    echo 'Serverless framework deploy failed!'
    exit 1
fi
rm .env
