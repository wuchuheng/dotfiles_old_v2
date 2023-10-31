#!/usr/bin/env zsh

TRUE=0 # the return successful code is 0 in unix system
FALSE=1

##
# get the runtime path
# @Use getRuntimeDirectory
# @Echo <string>
##
function getRuntimeDirectory() {
  echo "src/runtime"
}

##
# get the cli path
# @Use getCliDirectory
# @Echo <string path>
##
function getCliPath() {
  echo "src/cli";
}

function getCliDirectory() {
  local cliDirectory=$(getCliPath)
  if [[ -d "${cliDirectory}" ]]; then
    mkdir -p "${cliDirectory}"
  fi
  echo "${cliDirectory}"
}
