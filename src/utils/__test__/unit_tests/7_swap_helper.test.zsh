#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh # {testing_callback_handle}
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/swap_helper.zsh # {create_swap_file}

function create_swap_file_test() {
  local swapFile=$(create_swap_file)
  local exceptValue="${APP_BASE_PATH}/src/runtime/swap/$$/src_utils___test___unit_tests_7_swap_helper.test.zsh_8_1"
  except_str "${swapFile}" "${exceptValue}"
}

testing_callback_handle "create_swap_file_test" ""

function get_swap_content_test() {
  local swapFile=$(create_swap_file)
  local exceptValue="hello"
  echo "${exceptValue}" >> ${swapFile}
  local receiveValue=$(get_swap_content "${swapFile}")

  except_str "${receiveValue}" "${exceptValue}"
}

testing_callback_handle "get_swap_content_test" ""

function clean_swap_cache_test() {
  local pidList=($(ps au | awk 'NR==1{for(i=1;i<=NF;i++)if($i=="PID")col=i;next}{print $col}' | tr '\n' ' '))
  typeset -A pidArray=()
  for pid in ${pidList[@]}; do
   pidArray[$pid]=1
  done
#
  # get all pid used reference variable
  local swapDir="$(getRuntimeDirectory)/swap"
  local swapUsedPidList=($(ls ${swapDir}))
  local swapUsedPidCount=${#swapUsedPidList[@]}
  for swapUsedPid in "${swapUsedPidList[@]}"; do
    if [[ ! -v pidArray[$swapUsedPid] ]]; then
      (( swapUsedPidCount-- ))
    fi
  done

  clean_swap_cache

  local receiveValue=$(ls ${swapDir} | wc -l)
  ((receiveValue++))
  ((receiveValue--))

  except_str "${receiveValue}" "${swapUsedPidCount}"

}

testing_callback_handle "clean_swap_cache_test" "tmp"
