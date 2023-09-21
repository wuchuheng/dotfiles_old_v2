#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh
import @/src/config/const_conf.zsh


_cacheKeyForPassedStatus='_cacheKeyForPassedStatus'

##
# to set passed status
# @Use _setPassedStatus "<Boolean>"
# @Echo <void>
##
function _setPassedStatus() {
  local boolValue="$1"
  setStringValue "${_cacheKeyForPassedStatus}" "${boolValue}"
}

##
# get passed status.
# @Use _getPassedStatus
# @Echo <Boolean>
##
function _getPassedStatus() {
  local keyName="${_cacheKeyForPassedStatus}"
  getStringValue "${keyName}"
}

_cacheKeyForCurrentTestName='cacheKeyForCurrentTestName'

##
# get the name for current test.
# @Use _getCurrentTestName
# @Echo <string>
##
function _getCurrentTestName() {
  local keyName="${_cacheKeyForCurrentTestName}"
  getStringValue "${keyName}"
}

##
# set the name for current test
# @Use _setCurrentTestName "<test name>"
# @Echo <void>
##
function _setCurrentTestName() {
  local testName="$1"
  local keyName="${_cacheKeyForCurrentTestName}"
  setStringValue  "${keyName}" "${testName}"
}

_cacheKeyForCurrentTestDesc='cacheKeyForCurrentTestDesc'

##
# set description for current test.
# @Use _setCurrentTestDesc "<descriptionPointer>"
# @Echo <void>
##
function _setCurrentTestDesc() {
  local descPointer="$1"
  local keyName="${_cacheKeyForCurrentTestDesc}"
  setStringValueWithPointer "${keyName}" "${descPointer}"
}

##
# get current test name.
# @Use _getCurrentTestDesc
# @Echo <string>
##
function _getCurrentTestDesc() {
  local keyName="${_cacheKeyForCurrentTestDesc}"
  getStringValue "${keyName}"
}


if [[ -z ${globalCurrentTest} ]]; then
  declare -A -g globalCurrentTest=(
      [setPassedStatus]=_setPassedStatus
      [getPassedStatus]=_getPassedStatus
      [getName]=_getCurrentTestName
      [setName]=_setCurrentTestName
      [setDesc]=_setCurrentTestDesc
      [getDesc]=_getCurrentTestDesc
  )
fi

