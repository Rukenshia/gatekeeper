#!/bin/sh

# TODO: implement this

set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

payload="${TMPDIR}/gatekeeper-request"

cat > "$payload" <&0

api_key="$(jq -r '.source.api_key' "${payload}")"
team_url="$(jq -r '.source.team_url' "${payload}")"
payload_path="$(jq -r '.params.payload_path' "${payload}")"

data="$(curl -s -H "Authorization: Bearer ${api_key}" -H "Content-Type: application/json" --data "$(cat "${1}/${payload_path}")" "${team_url}/releases")"

echo "${data}"
echo "${data}" | jq '{version: {ref: .version}, metadata: [{name: "version", value: .version}, {name: "commit_hash", value: .commit_hash}, {name: "description", value: .description}]}' >&3

