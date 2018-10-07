#!/bin/sh

set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

payload="${TMPDIR}/gatekeeper-request"

cat > "$payload" <&0

api_key="$(jq -r '.source.api_key' "${payload}")"
team_url="$(jq -r '.source.team_url' "${payload}")"
version="$(jq -r '.version.ref' "${payload}")"

release_id="$(curl -s -H "Authorization: Bearer ${api_key}" "${team_url}/releases" | jq -r '.[] | select(.version=="'"${version}"'") | .id')"

data="$(curl -s -H "Authorization: Bearer ${api_key}" "${team_url}/releases/${release_id}")"

echo "${data}" > "${1}/release"

echo "${data}" | jq '{version: {ref: .version}, metadata: [{name: "version", value: .version}, {name: "released_at", value: .released_at}, {name: "commit_hash", value: .commit_hash}, {name: "description", value: .description}]}' >&3

