#!/usr/bin/env zsh

import ./helper.zsh # {get_all_sub_dir_by_path}
import ./list_helper.zsh # {join}

##
# get cli list
# @Use getCliList "<globalListReferenceName>"
# @return "<Boolean>"
##
function getCliDirList() {
  local globalListRefName=$1
  local listDir=($(get_all_sub_dir_by_path "$(getCliDirectory)"))
  local -A numberMapCli
  local cliNumbers=()
  # to get cli list
  local cli
  for cli in ${listDir[@]}; do
    globalListRef=()
    split_str_with_point "${cli}" "_" globalListRef
    local orderNo="${globalListRef[1]}"
    globalListRef=("${globalListRef[@]:1}")
    globalStrRef=''
    join '_' globalListRef globalStrRef
    numberMapCli[${orderNo}]="${globalStrRef}"
    # to push new element to cliNumbers
    cliNumbers+=("${orderNo}")

    unset globalStrRef globalListRef
  done

  # sort the cli list by number.
  cliNumbers=($(echo "${cliNumbers[@]}" | tr ' ' '\n' | sort -n))
  local cliNo
  local result=()
  for cliNo in "${cliNumbers[@]}"; do
    result+=("${cliNo}_${numberMapCli[${cliNo}]}")
  done

  eval "
    ${globalListRefName}=(\${result[@]})
  "

  return "${TRUE}"
}

##
# get cli name by numberCliDir
# @Use get_cli_name_by_number_cliDir "<numberCliDir>" "<outPutStrRef>"
# @return "<boolean>"
##
function get_cli_name_by_number_cli_dir() {
  local numberCliDir=$1
  local outputStrRef=$2
  globalListRef=()
  split_str_with_point "${numberCliDir}" "_" globalListRef
  globalListRef=("${globalListRef[@]:1}")
  globalStrRef=''
  join '_' globalListRef globalStrRef
  unset globalListRef
  eval "
    ${outputStrRef}=\"${globalStrRef}\"
  "
  unset globalStrRef

  return "${TRUE}"
}

