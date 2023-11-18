#!/usr/bin/env zsh

import ./helper.zsh # {get_all_sub_dir_by_path, split_str_with_point}
import ./list_helper.zsh # {join}
import ./ref_variable_helper.zsh # {assign_str_to_ref, generate_unique_var_name,get_list_from_ref }
import @/src/utils/debug_helper.zsh # {assert_not_empty}

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
  assert_not_empty "${1}"
  assert_not_empty "${2}"
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

##
# get current cli path
# @use get_current_cli_path "<outPutStrRef>"
# @return <boolean>
##
function get_current_cli_path() {
  local outPutStrRef="$1"
  local preFile="${funcfiletrace[1]}"
  local cliPath=$(getCliPath)
  local cliLen=${#cliPath}
  ((cliLen++))
  local cliRelativePath=${preFile:${cliLen}}
   # get the cli name with number from the relative path.
  local pathSliceRef=$( generate_unique_var_name )
  split_str_with_point "${cliRelativePath}" '/' "${pathSliceRef}"
  local pathSlice=($( get_list_from_ref "${pathSliceRef}" ))
  local numberCliDir=${pathSlice[1]}

  assign_str_to_ref "${cliPath}/${numberCliDir}" "${outPutStrRef}"
}

##
# get current cli name
# @use get_current_cli_name "<outPutStrRef>"
# @return <boolean>
##
function get_current_cli_name() {
  assert_not_empty "$1"
  local outPutStrRef="$1"
  local preFile="${funcfiletrace[1]}"
  local cliPath=$(getCliPath)
  local cliLen=${#cliPath}
  ((cliLen++))
  local cliRelativePath=${preFile:${cliLen}}

   # get the cli name with number from the relative path.
  local pathSliceRef=$( generate_unique_var_name )
  split_str_with_point "${cliRelativePath}" '/' "${pathSliceRef}"
  local pathSlice=($( get_list_from_ref "${pathSliceRef}" ))
  local numberCliDir=${pathSlice[1]}
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numberCliDir}" "${outPutStrRef}"

  return $?
}

##
# get the cli name by name
# @use get_cli_path_by_name <cli name> <result string output ref>
# @return <boolean>
function get_cli_path_by_name() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  local inputCliName=$1
  local outPutStrRef=$2
  local allCliDirPath=$(getCliDirectory)
  for cliNamePath in "${allCliDirPath}"/*; do
    local numberCliName=${cliNamePath:${#allCliDirPath} + 1}

    local cliNameRef=$(generate_unique_var_name)
    get_cli_name_by_number_cli_dir "${numberCliName}" "${cliNameRef}"
    local cliName=$(get_str_from_ref "${cliNameRef}")

    if [[ ${cliName} == ${inputCliName}_cli ]]; then
      assign_str_to_ref "${cliNamePath}" "${outPutStrRef}"
      return ${TRUE}
    fi
    break
  done
}

