# opge = One Password Get Env
opge() {
local item=$1

while read -r line;
do
IFS=$'\t' read -r var value <<<${line}
export "${var}=${value}"
done < <(op item get ${item} --reveal --format json | jq -r '.fields | .[] | select(.section.label == "Environment") | [.label,.value] | @tsv')
}
