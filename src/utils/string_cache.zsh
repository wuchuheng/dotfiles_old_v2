#!/usr/bin/env zsh

_globalCachePath="$(getRuntimeDirectory)/cache"

# to check the _globalCachePath directory is exist or not.
if [[ ! -d "$_globalCachePath" ]]; then
  mkdir -p "$_globalCachePath"
fi

##
# to cache a string with key.
# @Use setStringValue '<key name>' '<string>'
# @Echo <void>
##
function setStringValue() {
  local keyName="$1"
  local value="$2"
  echo "$value" > "${_globalCachePath}/${keyName}"
}

##
# to cache a string with key and string pointer.
# @Use setStringValueWithPointer '<key name>' '<string pointer>'
# @Echo <void>
##
function setStringValueWithPointer() {
  local keyName="$1"
  local stringPointer="$2"
  eval "
    local value=\$(echo \$${stringPointer})
    echo \$value > "${_globalCachePath}/${keyName}"
  "
}


##
# to get the string with key.
# @Use getStringValue '<key name>'
##
function getStringValue() {
  local keyName="$1"
  cat "${_globalCachePath}/${keyName}"
}