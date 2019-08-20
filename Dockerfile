FROM anand000/docker-aws-cli

# Get - Terraform
RUN \
    export TERRAFORM_CURRENT_BIN=$( \
    echo "$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | \
    jq -r -M '.current_version')") \
    && export TERRAFORM_CURRENT_BIN_URL=$( \
    echo "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | \
    jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | \
    jq -r -M '.current_version')_linux_amd64.zip") \
    && export TERRAFORM_CHECKSUM=$( \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_CURRENT_BIN}/terraform_${TERRAFORM_CURRENT_BIN}_SHA256SUMS | \
    grep linux_amd64.zip | \
    awk '{print $1}') \
    && curl -o /tmp/terraform.zip $TERRAFORM_CURRENT_BIN_URL \
    && echo "$TERRAFORM_CHECKSUM  /tmp/terraform.zip" | sha256sum -c - \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

# Config - Terraform
ENV TF_DATA_DIR "/root/.terraform"
COPY dot_terraformrc /root/.terraformrc

# Entrypoint
ENTRYPOINT /bin/bash