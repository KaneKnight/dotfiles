# Use MFA to get credentials
awsmfa() {
# Retrieve permanent AWS credentials
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

echo "AWS-CLI Profile: $AWS_CLI_PROFILE"
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