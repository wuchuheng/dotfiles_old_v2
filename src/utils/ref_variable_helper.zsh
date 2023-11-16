#!/usr/bin/env zsh

##
# This file contains the functions that are used to generate unique variable names
# @Use generate_unique_var_name
# @Echo "<unique var name>"
##
function generate_unique_var_name() {
  local prev_file_line="${funcfiletrace[1]}"
  local file_info=($(split_str "${prev_file_line}" ':'))
  local preNumberLine=${file_info[2]}
  local prefFile=${file_info[1]}

  # remove the prefix of the APP_BASE_PATH in the ${prefFile}.
  if [[ ${#prefFile} -gt ${#APP_BASE_PATH} ]]; then
    local appBasePathLen=${#APP_BASE_PATH}
    local prefixPath=${prefFile:0:${appBasePathLen}}
    if [[ "${prefixPath}" == "${APP_BASE_PATH}" ]]; then
      prefFile=${prefFile:${appBasePathLen} + 1}
    fi
  fi

  # to get current file
  # Replace '/' with '_' and '.' with '_'
  prefFile="${prefFile//\//_}"
  prefFile="${prefFile//\./_}"
  if [[ "${prefFile:0:1}" =~ [0-9] ]]; then
    # Replace the first character with '_'
    prefFile="_${prefFile:1}"
  fi

  local refName="${prefFile}_${preNumberLine}"

  # to check the variable globalRefNameList is already defined or not
  if [[ -z "${globalRefNameList}" ]]; then
    typeset -g -A globalRefNameList=()
  fi

  # to check the variable refName is exists or not in the globalRefNameList.
  if [[ -v globalRefNameList["$refName"] ]]; then
    # if exists then increment the value of refName
    local refNameLength=${#globalRefNameList}
    ((refNameLength++))
    refName="${refName}_${refNameLength}"
  fi

  # record the new unique refName.
  globalRefNameList[${refName}]="${refName}"

  echo "${refName}"
}

##
# assign the string value to the reference variable
# @Use assign_str_to_ref "<string value>" "<reference name>"
# @Return "<boolean>"
##
function assign_str_to_ref() {
  local strValue="${1}"
  local refName="${2}"
  eval "
    ${refName}=\"\${strValue}\"
  "

  return "${TRUE}"
}

##
# get the string value from reference variable name.
# @Use get_str_from_ref "<reference name>"
# @Echo "<string value>"
# @Return "<boolean>"
##
function get_str_from_ref() {
  local refName="${1}"
  eval "
    echo \"\${${refName}}\"
  "

  return "${TRUE}"
}

##
# get the list value from reference variable name.
# @Use get_list_from_ref "<reference name>"
# @Echo "(e1 e2 e3 ...)"
# @Return "<boolean>"
##
function get_list_from_ref() {
  local refName="${1}"
  eval "
    echo \"\${${refName}[@]}\"
  "

  return "${TRUE}"
}
