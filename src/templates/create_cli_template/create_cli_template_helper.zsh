#!/usr/bin/env zsh

import @/src/config/const_conf.zsh # {getCliDirectory, TRUE, FALSE}
import @/src/utils/helper.zsh # {split_str_with_point}
import ../../utils/log.zsh # {log}


##
# get the cli name from command line.
# @Use get_input_cli_name <CLI_NAME_REF>
# @Echo <string>
##
function get_input_cli_name() {
  local CLI_NAME_REF=$1
  echo -n "Please enter the name of cli tools you want to create: "
  eval " read ${CLI_NAME_REF}"
  eval "${CLI_NAME_REF}=\$(echo \$${CLI_NAME_REF} | sed -E 's/ +/_/g')"
}

##
# @Use check_if_cli_name_is_exist "<cli name>"
# @Return <boolean>
#
function check_if_cli_name_is_exist() {
  local CLI_NAME="$1"
  local cliDirector=$(getCliDirectory)
  if [[ ! -d ${cliDirector} ]];then
    return "${FALSE}"
  fi
  local cliList=($(ls "${cliDirector}"))
  local empty=0
  if [[ "${#cliList[@]}" -eq "${empty}" ]]; then
    return "${FALSE}"
  fi
  # get cli name without number
  for cliWithNumber in "${cliList[@]}"; do
    result=()
    split_str_with_point "${cliWithNumber}" "_" "result"
    if [[ "${#result[@]}" -lt "2" ]]; then
      continue
    fi
    local cliName=''
    local key=1
    for val in "${result[@]}"; do
        if [[ ${key} -eq 1 ]]; then
          (( key++ ))
          continue
        fi
        if [[ ${key} -eq ${#result[@]} ]]; then
          break
        fi
        cliName="${cliName}_${val}"
        (( key++ ))
    done
    cliName=${cliName:1}
    if [[ "${cliName}" == "${CLI_NAME}" ]]; then
      return "${TRUE}"
    fi
  done

  return "${FALSE}"
}
