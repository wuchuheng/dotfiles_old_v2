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
    typeset -g globalRefNameList=()
  fi

  # to check the variable refName is exists or not in the globalRefNameList.
  if [[ "${globalRefNameList[(ie)${refName}]}" -ne 0 ]]; then
    # if exists then increment the value of refName
    local refNameLength=${#globalRefNameList}
    ((refNameLength++))
    refName="${refName}_${refNameLength}"
  fi
  globalRefNameList+=("${refName}")

  echo "${refName}"
}
