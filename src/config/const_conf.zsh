#!/usr/bin/env zsh

TRUE=0 # the return successful code is 0 in unix system
FALSE=1

##
# get the runtime path
# @Use getRuntimeDirectory
# @Echo <string>
##
function getRuntimeDirectory() {
  echo "${APP_BASE_PATH}/src/runtime"
}

function getCliDirectory() {
  local cliDirectory="src/cli"
  if [[ -d "${cliDirectory}" ]]; then
    mkdir -p "${cliDirectory}"
  fi
  echo "${cliDirectory}"
}

##
# get the cli path
# @Use getCliDirectory
# @Echo <string path>
##
function getCliPath() {
  echo "src/cli";
}