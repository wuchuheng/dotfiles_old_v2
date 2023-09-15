#!/usr/bin/env zsh

import ../config/const_conf.zsh
import @/src/handlers/testing_callback_handler/flush_output_for_testing_callback/flush_output_for_testing_callback.zsh
import @/src/services/flush_output_in_terminal_service.zsh

declare -A -g globalCurrentTest=(
    [name]=''
    [desc]=''
    [isPass]=${TRUE}
)

# Declare the function with two pro: the callback contained a testing logic, the testing name and the testing description.
function testing_callback_handle() {
    local callback="$1" # the callback function contained a testing logic
    globalCurrentTest[name]="$1"
    globalCurrentTest[desc]="$2"
    globalCurrentTest[isPass]="${TRUE}"
    flushOutputBeforeTesting "${globalCurrentTest[name]}" "$(( globalAllTestResults[totalSuccessfulTests] + globalAllTestResults[totalFailedTests] + 1 ))" "${globalCurrentTest[desc]}"
    echo "before call back >>> "${globalCurrentTest[isPass]}
    globalCurrentTestOutput=$($callback)
    echo "after call back >>> "${globalCurrentTest[isPass]}
    pushToFlushOutputWithStrPointer 'globalCurrentTestOutput'
    flushOutputAfterTesting "${globalCurrentTest[isPass]}"
    if [[ ${globalCurrentTest[isPass]} -eq ${TRUE} ]]; then
      ((globalAllTestResults[totalSuccessfulTests]++))
    else
      ((globalAllTestResults[totalFailedTests]++))
    fi
}
