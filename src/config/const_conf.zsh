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

##
# get the runtime directory for cli
# @Use getCliRuntimeDirectory
# @Echo <string>
function getCliRuntimeDirectory() {
  echo "$(getRuntimeDirectory)/cli_runtime"
}

##
# get the cli path
# @Use getCliDirectory
# @Echo <string path>
##
function getCliPath() {
  echo "${APP_BASE_PATH}/src/cli";
}

function getCliDirectory() {
  local cliDirectory=$(getCliPath)
  if [[ -d "${cliDirectory}" ]]; then
    mkdir -p "${cliDirectory}"
  fi
  echo "${cliDirectory}"
}
