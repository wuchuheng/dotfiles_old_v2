#!/usr/bin/env zsh

import @/src/utils/helper.zsh
import @/src/config/const_conf.zsh
import ./../services/flush_output_in_terminal_service.zsh

##
# 断言字符
# except_string "excepted str" "received str"
##
function except_str() {
  local frame=${#funcstack}
  frame=$((frame - 1))
  local prev_idx=$(( ${#funcfiletrace[@]} - 4 ))
  local prev_file_line="${funcfiletrace[$prev_idx]}"
  local file_info=($(split_str "${prev_file_line}" ':'))
  local prev_line=${file_info[2]}
  local prev_file=${file_info[1]}
  if [[ $(${globalCurrentTest[getPassedStatus]}) -eq ${TRUE} && "$1" == "$2" ]]; then
    ${globalCurrentTest[setPassedStatus]} ${TRUE}
  else
    ${globalCurrentTest[setPassedStatus]} ${FALSE}
  fi

  if [[ $(${globalCurrentTest[getPassedStatus]}) -eq ${TRUE} ]]; then
    return ${TRUE}
  else
    local relative_file=${prev_file:${#APP_BASE_PATH} + 1}
    local output=$(eval '
    printf "$(bg_red_print " FAIL ") ${relative_file}:${prev_line}\n"
    printf "    $(pink_print ●) $(pink_print "$(${globalCurrentTest[getName]})")\n"
    printf "    Expected: $(green_print "$1")\n"
    printf "    Received: $(red_print "$2")\n"
    get_a_part_of_code ${prev_file} ${prev_line}
    ')
    echo ${output}
    # echo ${globalCurrentTest[isPass]}
    # pushToFlushOutput "${output}"
    return ${FALSE}
  fi
}

