#!/usr/bin/env zsh

typeset -g globalKeyMapValueCacheDirName='keyMapValueCache'

_globalCachePath="$(getRuntimeDirectory)/${globalKeyMapValueCacheDirName}"

# to check the _globalCachePath directory is existed or not.
if [[ ! -d "$_globalCachePath" ]]; then
  mkdir -p "$_globalCachePath"
fi

##
# to cache a string with key.
# @Use setStringValue '<key name>' '<string>' '<cache space>'
# @Echo <void>
##
function setStringValue() {
  local keyName="$1"
  local value="$2"
  local cacheSpace=$3

  local dirPath=${_globalCachePath}
  # if the cacheSpace is not empty.
  if [[ -n "$cacheSpace" ]]; then
    dirPath="$(getRuntimeDirectory)/${cacheSpace}"
    # to check the cache space directory is existed or not.
    if [[ ! -d "$dirPath" ]]; then
      mkdir -p "$dirPath"
    fi
  fi

  echo "$value" > "${dirPath}/${keyName}"
}

##
# to cache a string with key and string pointer.
# @Use setStringValueWithPointer '<key name>' '<string pointer>' '<space name>'
# @Echo <void>
##
function setStringValueWithPointer() {
  local keyName="$1"
  local stringPointer="$2"
  local cacheSpace=$3
  local dirPath=${_globalCachePath}
  # if the cacheSpace is not empty.
  if [[ -n "$cacheSpace" ]]; then
    dirPath="$(getRuntimeDirectory)/${cacheSpace}"
    # to check the cache space directory is existed or not.
    if [[ ! -d "$dirPath" ]]; then
      mkdir -p "$dirPath"
    fi
  fi

  eval "
    local value=\$(echo \$${stringPointer})
    echo \$value > "${dirPath}/${keyName}"
  "
}

##
# to get the string with key.
# @Use getStringValue '<key name>' '<space name>'
##
function getStringValue() {
  local keyName="$1"
  local cacheSpace=$2
  local dirPath=${_globalCachePath}
  # if the cacheSpace is not empty.
  if [[ -n "$cacheSpace" ]]; then
    dirPath="$(getRuntimeDirectory)/${cacheSpace}"
    # to check the cache space directory is existed or not.
    if [[ ! -d "$dirPath" ]]; then
      mkdir -p "$dirPath"
    fi
  fi
  cat "${dirPath}/${keyName}"
}