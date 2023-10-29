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
  local -A hashMap
  local key value
  for cli in ${(@v)listDir}; do
    globalListRef=()
    split_str_with_point "${cli}" "_" globalListRef
    unset "globalListRef[1]"
    globalStrRef=''
    join '_' globalListRef globalStrRef
    echo "->${globalStrRef}"
   #  hashMap[${globalListRef[1]}]=
    unset globalListRef
  done
}
