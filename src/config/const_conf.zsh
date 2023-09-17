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