#!/usr/bin/env zsh

import @/src/utils/helper.zsh
import @/src/handlers/testing_callback_handler/flush_output_for_testing_callback/testing_name_output_history.zsh

_test_name_len=0

##
# to flush output in terminal before testing
# @use flushOutputBeforeTesting "<testName>" "<testCount>" "<testDesc>"
# @echo <void>
##
function flushOutputBeforeTesting() {
    local testName="$1"
    local testCount="$2"
    local testDesc="$3"
    local test_name_len=${#testName}
    if (( _test_name_len < test_name_len )); then
      _test_name_len=${test_name_len}
      local lengthInHistory=$(getHistoryOutputLengthForTesting)
      # to update the length of test name in history output.
      for (( historyOutputIndex=1; historyOutputIndex<=${lengthInHistory}; historyOutputIndex++ )); do
         local keyForGlobalHistoryOutput=${historyOutputIndex}
         getHistoryOutputForTestingItemByIndex "${historyOutputIndex}" _globalHistoryOutputItemPoint
         _globalHistoryOutputItemPoint[3]=${_test_name_len}
         updateHistoryOutputForTestingItem "${keyForGlobalHistoryOutput}" "_globalHistoryOutputItemPoint"
      done
    fi
    local testState="loading"
    declare -a -g globalListForOutPutHistoryPointer=(
      "${testState}"
      "${testName}"
      "${_test_name_len}"
      "${testCount}"
      "${testDesc}"
    )
    local encodeStrForOutputHistory=$(listEncode "globalListForOutPutHistoryPointer")
    pushHistoryOutputForTesting "${encodeStrForOutputHistory}"
}

##
# flush output after current test name.
# @Use flushOutputAfterTesting "<${BOOLEAN}>"
##
function flushOutputAfterTesting() {
    local isPassTest="$1"
    local lastIndexInTestInformation=$(getHistoryOutputLengthForTesting)
    local lastTestInformationPointer='_lastTestInformationPointer'
    getHistoryOutputForTestingItemByIndex "${lastIndexInTestInformation}" ${lastTestInformationPointer}
    if [[ ${isPassTest} -eq ${TRUE} ]]; then
      eval " ${lastTestInformationPointer}[1]='successful' "
    else
      eval " ${lastTestInformationPointer}[1]='failed' "
    fi
    updateHistoryOutputForTestingItem "${lastIndexInTestInformation}" "${lastTestInformationPointer}"
}
