#!/usr/bin/env zsh

import @/src/utils/debug_helper.zsh # {assert_not_empty}

function _get_swap_dir() {
  local runtimeDir=$(getRuntimeDirectory)
  local swapDir="${runtimeDir}/swap/$$"
  if [[ ! -d ${swapDir} ]]; then
    mkdir -p "${swapDir}"
  fi
  echo "${swapDir}"
}

##
# create a swap file and echo the swap file path to stdout
# @use create_swap_file
##
function create_swap_file() {
  local swapDir="$(_get_swap_dir)"
  local preFileLineNum="${funcfiletrace[1]:${#APP_BASE_PATH} + 1}"
  local preFile='';
  local lineNum='';
  local isPathPart=${TRUE}
  for (( i = 0; i <= ${#preFileLineNum[@]}; i++)); do
    local char="${preFileLineNum[$i]}"
    if [[ ${char} == ':' ]]; then
      isPathPart="${FALSE}"
      continue
    fi
    if [[ ${isPathPart} -eq ${TRUE} ]]; then
      if [[ ${char} == '/' ]]; then
        char='_'
      fi
      preFile="${preFile}$char"
    else
      lineNum="${lineNum}$char"
    fi
  done
  # create a swapfile
  local swapFile="${preFile}_${lineNum}"
  local sameNameFileCount=$(ls ${swapDir} | grep "${swapFile}" | wc -l )
  (( sameNameFileCount++ ))
  local swapFilePath="${swapDir}/${swapFile}_${sameNameFileCount}"
  touch "${swapFilePath}"

  echo "${swapFilePath}"
}

##
# get the content from swap file
# @use get_swap_content <swap file>
# @echo <content>
function get_swap_content() {
  assert_not_empty "$1"
  local swapFile=$1

  cat "$swapFile"
}

function clean_swap_cache() {
  local pidList=($(ps au | awk 'NR==1{for(i=1;i<=NF;i++)if($i=="PID")col=i;next}{print $col}' | tr '\n' ' '))
  typeset -A pidArray=()
  for pid in ${pidList[@]}; do
   pidArray[$pid]=1
  done

  # get all pid used reference variable
  local swapDir="$(_get_swap_dir)"
  swapDir="$(dirname ${swapDir})"
  local swapUsedPidList=($(ls ${swapDir}))
  for swapUsedPid in "${swapUsedPidList[@]}"; do
    if [[ ! -v pidArray[$swapUsedPid] ]]; then
      log DEBUG "clean ref cache dir: ${swapUsedPid}"
      rm -rf "${swapDir}/${swapUsedPid}"
    fi
  done
}
