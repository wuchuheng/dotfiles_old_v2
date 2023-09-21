#!/usr/bin/env zsh

_globalTotalSuccessFulTest=0
##
# get the total number of successful tests.
# @Use _getTotalSuccessfulTests
# @Echo <number string>
##
function _getTotalSuccessfulTests() {
  echo "${_globalTotalSuccessFulTest}"
}

_globalTotalFailedTest=0
##
# get the total number of failed tests.
# @Use _getTotalFailedTests
# @Echo <number string>
##
function _getTotalFailedTests() {
  echo "${_globalTotalFailedTest}"
}

##
# increment the total number of failed with 1.
# @Use _incrementTotalFailedTests
# @Echo <void>
##
function _incrementTotalFailedTests() {
  ((_globalTotalFailedTest++))
}

##
# increment the total number of successful with 1.
# @Use _incrementTotalSuccessfulTests
# @Echo <void>
##
function _incrementTotalSuccessfulTests() {
  _globalTotalSuccessFulTest=$((_globalTotalSuccessFulTest + 1))
}

# if the globalAllTestResults is not initialized, initialize it.
if [[ -z ${globalAllTestResults} ]]; then
  declare -A -g globalAllTestResults=(
    [getTotalSuccessfulTests]=_getTotalSuccessfulTests
    [incrementTotalSuccessfulTests]=_incrementTotalSuccessfulTests

    [incrementTotalFailedTests]=_incrementTotalFailedTests
    [getTotalFailedTests]=_getTotalFailedTests
  )
fi