#!/bin/bash

## ===== [ Sub Functions] =====
function convert() {
  local con_path="$1"
  local temp_1="$(awk '/RUN tdnf/{exit} 1' "${con_path}")"
  local temp_2="$(awk '/RUN tdnf/,0' "${con_path}")"
  local result=""

  result+="${temp_1}"$'\n\n'
  result+="RUN tdnf install -y shadow >> /dev/null \\"$'\n'
  result+="  && groupadd -r postgres --gid=999 \\"$'\n'
  result+="  && useradd -m -r -g postgres --uid=999 postgres"$'\n\n'
  result+="$(sed -e "s/shadow //g" -e '/groupadd/d' -e '/useradd/d' -e '/ln -s/d' -e 's/share\/postgresql\.conf\.sample/share\/postgresql\/postgresql\.conf\.sample/g'  <<< "${temp_2}")"



  echo "${result}" > "${con_path}"
}

## Main
main() {
  ## ===== [ includes ] =====

  ## ===== [ Constants and Variables ] =====
  local path="$1"

  ## ===== [ run functions ] =====

  convert "${path}"
}

main "${@}"