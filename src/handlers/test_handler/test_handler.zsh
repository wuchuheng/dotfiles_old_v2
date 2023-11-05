#!/usr/bin/env zsh

import @/src/utils/helper.zsh
import @/src/utils/color_printf.zsh
import ./../../services/flush_output_in_terminal_service.zsh
import ./global_all_test_results.zsh # globalAllTestResults
import ../global_current_test.zsh # globalCurrentTest

##
# Handle test files
#
# @use test_handle "(test_file1, test_file2, ...)"
# @echo #void
##
function test_handle() {
  local startTimestamp=$(date +%s )
  local ALL_UNIT_TEST_FILES=($@)
  for test_file in "${ALL_UNIT_TEST_FILES[@]}"; do
    local currentTestFile=${APP_BASE_PATH}/${test_file}
    # to set the flush output for current test file.
    local testFileLog=$(printf "$(blob_bg_green_gray_print ' TESTING... ') ${test_file}")
    pushToFlushOutput "${testFileLog}"
    local flushOutputItemIndex=$(getFlushOutputLength)
    # to test current test file.
    source "${currentTestFile}"
    # to changed output status for current test file.
    local currentTestStatus=$(${globalCurrentTest[getPassedStatus]})
    if [[ ${currentTestStatus} == ${TRUE} ]]; then
      testFileLog=$(printf "$(blob_bg_green_gray_print ' PASSED ') ${test_file}")
    else
      testFileLog=$(printf "$(blob_bg_red_gray_print ' FAILED ') ${test_file}")
    fi
    _globalOutputPointer="${testFileLog}"
    updateOutput "${flushOutputItemIndex}" "_globalOutputPointer"
  done

 local endTimestamp=$(date +%s )
 local durationTime=$((endTimestamp - startTimestamp ))

 local successfulTestCount=$(${globalAllTestResults[getTotalSuccessfulTests]})
 local failedTestCount=$(${globalAllTestResults[getTotalFailedTests]})
 local testedTotal=$((${successfulTestCount} + ${failedTestCount}))
 local failedReportStr="$(red_print ${failedTestCount}) $(red_print 'failed')"
 printf "\n\n"
 printf "$(bold_print 'Tests:')        ${failedReportStr}, $(green_print "${successfulTestCount}" $BOLD) $(green_print 'passed'), %d total\n" ${testedTotal}
 printf "$(bold_print 'Time:')         ${durationTime} s\n"
 printf "$(bold_print 'Test files:')   ${#ALL_UNIT_TEST_FILES} f\n"
 printf "Ran all test files.\n"
 if [ $(${globalAllTestResults[getTotalFailedTests]}) != 0 ]; then
   printf "$(red_print 'Test failed. See above for more details')\n"
   exit 1
 else
   exit 0
 fi
}

