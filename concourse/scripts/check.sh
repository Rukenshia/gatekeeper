#!/bin/sh

set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

payload="${TMPDIR}/gatekeeper-request"

cat > "$payload" <&0

api_key="$(jq -r '.source.api_key' "${payload}")"
team_url="$(jq -r '.source.team_url' "${payload}")"

echo "Using api_key ${api_key} on ${team_url}"

curl -s -H "Authorization: Bearer ${api_key}" "${team_url}"/releases?released=true | jq -r '[.[] | {ref: .version}] | .[:1]' >&3

