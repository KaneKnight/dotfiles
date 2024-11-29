#!/bin/zsh

# Use MFA to get credentials
awsmfa() {
    # Retrieve permanent AWS credentials
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    # Define key we store permanent (unprivileged) AWS creds in
    OPGE_KEY="Env/AWS/Kane"
    opge $OPGE_KEY

    while read -r line;
    do
    IFS=$'\t' read -r var value <<<${line}
    export "${var}=${value}"
    done < <(op item get $OPGE_KEY --reveal --format json | jq -r '.fields | .[] | select(.section.label == "Environment") | [.label,.value] | @tsv')

    local user_name=$(aws sts get-caller-identity --query Arn --output text | awk -F/ '{print $2}')
    local ARN_OF_MFA=$(aws iam list-mfa-devices --user-name $user_name  --query 'MFADevices[0].SerialNumber' --output text)
    local DURATION=86400

    echo "Enter an MFA token:"
    read MFA_TOKEN_CODE

    export AWS_PROFILE=mfa
    echo "AWS Profile: $AWS_PROFILE"
    echo "MFA ARN: $ARN_OF_MFA"
    echo "MFA Token Code: $MFA_TOKEN_CODE"

    read AWS_ACCESS_KEY_ID AWS_SESSION_EXPIRATION AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< \
    $( aws sts get-session-token \
    --duration $DURATION  \
    --serial-number $ARN_OF_MFA \
    --token-code $MFA_TOKEN_CODE \
    --output text  | awk '{ print $2, $3, $4, $5 }')

    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN
    export AWS_SESSION_EXPIRATION
}

pgmfa() {
    local ENV=$1

    # Permanent AWS credentials should be in 1PW in the private employee vault - give the secret key here
    local AWS1PWCREDS="Env/AWS/Kane"

    # Preserve any transient AWS creds in the current environment
    local old_aws_access_key_id=${AWS_ACCESS_KEY_ID}
    local old_aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
    local old_aws_session_token=${AWS_SESSION_TOKEN}

    # Determine AWS role we want to become - this is env specific
    export PGHOST=$(aws rds describe-db-instances --query 'DBInstances[*].Endpoint.Address' | jq -r --arg search "${ENV}" '.[] | select(contains($search))')
    AWS_ROLE_ARN=$(aws iam list-roles |  jq -r --arg search "operations-rds-${ENV}" '.Roles[] | select(.RoleName | contains($search)) | .Arn')
    USER_NAME=$(aws sts get-caller-identity --query Arn --output text | awk -F/ '{print $2}')
    MFA_ARN=$(aws iam list-mfa-devices --user-name "$USER_NAME"  --query 'MFADevices[0].SerialNumber' --output text)

    echo "Enter an MFA token:"
    read -r MFA_TOKEN_CODE

    opge ${AWS1PWCREDS}
    unset AWS_SESSION_TOKEN

    # Set new AWS creds with new rols
    read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< \
    "$( aws sts assume-role \
    --no-cli-auto-prompt \
    --role-arn="${AWS_ROLE_ARN}" \
    --role-session-name="$(whoami)-rds" \
    --duration="3600"  \
    --serial-number="$MFA_ARN" \
    --token-code="$MFA_TOKEN_CODE" \
    --query='Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output=text  | awk '{ print $1, $2, $3 }')"

    if [[ -z ${AWS_ACCESS_KEY_ID} ]]; then
    echo "Failed to assume role"
    set +x
    return 1
    fi

    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN
    export AWS_ROLE_ARN

    # Generate temporary DB credentials with AWS role credentials
    export PGUSER=ops_rds-"${ENV}"
    read -r PGPASSWORD <<< \
    "$( aws rds generate-db-auth-token \
    --no-cli-auto-prompt \
    --region eu-west-1 \
    --hostname "${PGHOST}" \
    --port 5432 \
    --username ${PGUSER})"

    if [[ -z ${PGPASSWORD} ]]; then
    echo "Failed to get PG creds"
    set +x
    return 1
    fi

    #PGCREDSEXPIRY=$(date -d '+1 hour' --iso-8601=seconds)

    export AWS_ACCESS_KEY_ID=${old_aws_access_key_id}
    export AWS_SECRET_ACCESS_KEY=${old_aws_secret_access_key}
    export AWS_SESSION_TOKEN=${old_aws_session_token}

    unset AWS_ROLE_ARN

    export PGPASSWORD
    #export PGCREDSEXPIRY
    export PGENV="${ENV} (${PGCREDSEXPIRY})"
}