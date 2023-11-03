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
# @Echo <value>
# @Return <boolean> true: the key is existed, false: the key is not existed.
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

  local cacheFile="${dirPath}/${keyName}"
  # if the cache file is not existed. then return false.
  if [[ ! -f ${cacheFile} ]]; then
    echo ''
    return ${FALSE}
  fi
  local cacheValue=$(cat ${cacheFile})
  # if the cache value is empty. then return false.
  if [[ -z "$cacheValue" ]]; then
    echo ''
    return ${FALSE}
  fi

  echo "${cacheValue}"
  return ${TRUE}
}