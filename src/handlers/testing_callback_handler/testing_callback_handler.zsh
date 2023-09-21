#!/usr/bin/env zsh

import ../../config/const_conf.zsh
import @/src/handlers/testing_callback_handler/flush_output_for_testing_callback/flush_output_for_testing_callback.zsh
import @/src/services/flush_output_in_terminal_service.zsh
import ../global_current_test.zsh


# Declare the function with two pro: the callback contained a testing logic, the testing name and the testing description.
function testing_callback_handle() {
    local callback="$1" # the callback function contained a testing logic
    ${globalCurrentTest[setName]} "$1"
    globalCurrentTestDescPointer='globalCurrentTestDescPointer'
    eval "${globalCurrentTestDescPointer}='$2'"
    ${globalCurrentTest[setDesc]} "$2"
    ${globalCurrentTest[setDesc]} "${globalCurrentTestDescPointer}"
    ${globalCurrentTest[setPassedStatus]} "${TRUE}"
    local totalSuccessfulTests=$(${globalAllTestResults[getTotalSuccessfulTests]})
    local totalFailedTests=$(${globalAllTestResults[getTotalFailedTests]})
    flushOutputBeforeTesting "$(${globalCurrentTest[getName]})" "$(( totalSuccessfulTests + totalFailedTests + 1 ))" "$(${globalCurrentTest[getDesc]})"
    globalCurrentTestOutput=$($callback)
    pushToFlushOutputWithStrPointer 'globalCurrentTestOutput'
    flushOutputAfterTesting "$(${globalCurrentTest[getPassedStatus]})"
    if [[ $(${globalCurrentTest[getPassedStatus]}) -eq ${TRUE} ]]; then
      ${globalAllTestResults[incrementTotalSuccessfulTests]}
    else
      ${globalAllTestResults[incrementTotalFailedTests]}
      pushToFlushOutput "\n"
    fi
}
