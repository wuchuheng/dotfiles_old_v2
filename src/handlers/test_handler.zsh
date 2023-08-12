#!/usr/bin/env zsh

import @/src/utils/helper.zsh
import @/src/utils/color_printf.zsh

##
# Handle test files
#
# @use test_handle "(test_file1, test_file2, ...)"
# @echo #void
##
function test_handle() {
  local ALL_UNIT_TEST_FILES=($@)
  is_all_pass=0
  declare -g global_total_tests=0
  declare -g global_total_pass=0
  declare -g global_total_fail=0
  total_test_files=0
  startTimestamp=$(date +%s)
  test_count=0
  for test_file in "${ALL_UNIT_TEST_FILES[@]}"; do
    declare -g global_test_file_is_pass=0;
    declare -g global_pass_test_desc_items=(); # collect all pass test description items.
    declare -g global_pass_test_name_items=(); # collect all pass test name items.
    declare -g global_pass_test_results=(); # collect all result of test.
    declare -g global_max_pass_tests_len=0; # get the max test name length.
    declare -g global_test_file=${APP_BASE_PATH}/${test_file}
    source ${global_test_file}
    if [ $global_test_file_is_pass -eq 0 ];then
      printf "$(blob_bg_green_white_print " PASS ") ${test_file}\n"
      for ((i=1; i<=${#global_pass_test_name_items[@]}; i++)); do
  	    ((test_count++))
  	    printf "%s\n" "${global_pass_test_results[$i]}"
  	    str=`printf "  ✔ %-3s%-${global_max_pass_tests_len}s: %s\n"  $test_count "${global_pass_test_name_items[$i]}" "${global_pass_test_desc_items[$i]}"`
  	    green_print "$str"
  	    printf "\n"
      done
      printf "\n"
    else
      is_all_pass=1
    fi
    ((total_test_files++))
  done

  endTimestamp=$(date +%s )
  durationTime=$((endTimestamp - startTimestamp ))

  printf "$(bold_print 'Tests:')        $(red_print ${global_total_fail}) $(red_print 'failed'), $(green_print "${global_total_pass}" $BOLD) $(green_print 'passed'), %d total\n" ${global_total_tests}
  printf "$(bold_print 'Time:')         ${durationTime} s\n"
  printf "$(bold_print 'Test files:')   ${total_test_files} f\n"
  printf "Ran all test files.\n"
  if [ ${is_all_pass} != 0 ]; then
    printf "$(red_print 'Test failed. See above for more details')\n"
    exit 1
  else
    exit 0
  fi
}

