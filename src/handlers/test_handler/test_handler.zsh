#!/usr/bin/env zsh

import @/src/utils/helper.zsh
import @/src/utils/color_printf.zsh
import ./../services/flush_output_in_terminal_service.zsh

##
# Handle test files
#
# @use test_handle "(test_file1, test_file2, ...)"
# @echo #void
##
function test_handle() {
  local ALL_UNIT_TEST_FILES=($@)
  declare -A -g globalAllTestResults=(
    [totalSuccessfulTests]=0
    [totalFailedTests]=0
    [startTimestamp]="$(date +%s)"
    [totalTestFiles]="${#ALL_UNIT_TEST_FILES}"
    [testNameMaxLength]=0
  )
  for test_file in "${ALL_UNIT_TEST_FILES[@]}"; do
    local currentTestFile=${APP_BASE_PATH}/${test_file}
    local testFileLog=$(printf "$(blob_bg_green_white_print " TESTING... ") ${test_file}")
    pushToFlushOutput "${testFileLog}"
    local flushOutputItemIndex=$(getFlushOutputLength)
    source "${currentTestFile}"
#    sleep 5
#    testFileLog=$(printf "$(blob_bg_green_white_print " FAILED ") ${test_file}")
#    updateOutput "${flushOutputItemIndex}" "${testFileLog}"
#    if [ 1 -eq 0 ];then
#      printf "$(blob_bg_green_white_print " PASS ") ${test_file}"
#      for ((i=1; i<=${#global_pass_test_name_items[@]}; i++)); do
#  	    ((test_count++))
#  	    # printf "%s\n" "${global_test_results[$i]}"
#  	    str=`printf "  ✔ %-3s%-${global_max_pass_tests_len}s: %s\n"  $test_count "${global_pass_test_name_items[$i]}" "${global_pass_test_desc_items[$i]}"`
#  	    # green_print "$str"
#      done
#      printf "\n"
#    else
#      is_all_pass=1
#    fi
#    ((total_test_files++))
  done
#
#  endTimestamp=$(date +%s )
#  durationTime=$((endTimestamp - startTimestamp ))
#
#  printf "$(bold_print 'Tests:')        $(red_print ${global_total_fail}) $(red_print 'failed'), $(green_print "${global_total_pass}" $BOLD) $(green_print 'passed'), %d total\n" ${global_total_tests}
#  printf "$(bold_print 'Time:')         ${durationTime} s\n"
#  printf "$(bold_print 'Test files:')   ${total_test_files} f\n"
#  printf "Ran all test files.\n"
#  if [ ${is_all_pass} != 0 ]; then
#    printf "$(red_print 'Test failed. See above for more details')\n"
#    exit 1
#  else
#    exit 0
#  fi
}

