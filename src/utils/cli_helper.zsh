#!/usr/bin/env zsh

import ./helper.zsh # {get_all_sub_dir_by_path}

##
# get cli list
# @Use getCliList "<globalListReferenceName>"
# @return "<Boolean>"
##
function getCliDirList() {
  local globalListRefName=$1
  local listDir=$(get_all_sub_dir_by_path "$(getCliDirectory)")
  local -A hashMap
  local key value
  for cli in ${listDir}; do
    globalListRef=()
    split_str_with_point "${cli}" "_" globalListRef
    unset "globalListRef[1]"
    local cliInfo cliName
    for cliInfo in ${globalListRef}; do

    done

    hashMap[${globalListRef[1]}]=

    unset globalListRef
  done
}
