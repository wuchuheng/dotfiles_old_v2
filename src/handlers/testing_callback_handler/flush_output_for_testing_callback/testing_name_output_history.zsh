#!/usr/bin/env zsh
import @/src/services/flush_output_in_terminal_service.zsh

declare -g -a _globalIndexListForFlushOutput=()

##
# get output for testing
# @use getOutputForTesting "<encodeString>" #"[loading|failed|successful]" "<testName>" "<testNameLen>" "<testCount>" "<testDesc>"
# @echo "<string>"
##
function getOutputForTesting() {
  local encodeStr="$1"
  listDecode "${encodeStr}" 'globalDecodeResultPointer'
  local testState="${globalDecodeResultPointer[1]}"
  local testName="${globalDecodeResultPointer[2]}"
  local testNameLen="${globalDecodeResultPointer[3]}"
  local testCount="${globalDecodeResultPointer[4]}"
  local testDesc="${globalDecodeResultPointer[5]}"
  local emoji=""
  case $testState in
  'loading')
    emoji="⏳"
    ;;
  'failed')
    emoji="❌"
    ;;
  'successful')
    emoji="✔︎"
    ;;
  esac
  local output=$(printf "  %s %-3s%-${testNameLen}s: %s\n" "${emoji}"  "${testCount}" "${testName}" "${testDesc}")
  printf "%s" "${output}"
}

##
# @use pushHistoryOutputForTesting "${encodeStrForOutputHistory}"
# @echo <void>
##
function pushHistoryOutputForTesting() {
  local encodeStrForOutputHistory="$1"
  # push output to terminal.
  local output=$( getOutputForTesting "${encodeStrForOutputHistory}")
  pushToFlushOutput "${output}"
  # to store current test information.
  local flushOutputLength="$(getFlushOutputLength)"
  listDecode "${encodeStrForOutputHistory}" 'globalDecodeResultPointer'
  globalDecodeResultPointer[6]="${flushOutputLength}"
  local newItem=$( listEncode 'globalDecodeResultPointer' )
  _globalIndexListForFlushOutput+=("${newItem}")
}

##
# to update a history output for testing.
# @use updateHistoryOutputForTestingItem "<index>" "<itemPointer>"
#
function updateHistoryOutputForTestingItem() {
  local itemPointer=$2
  # to update current test name information
  local changedItem=$(listEncode "${itemPointer}")
  _globalIndexListForFlushOutput[$1]="${changedItem}"
  # to update the output terminal output string and flush the output in terminal.
  local testState=$(eval "echo \${${itemPointer}[1]}")
  local testName=$(eval "echo \${${itemPointer}[2]}")
  local testNameLen=$(eval "echo \${${itemPointer}[3]}")
  local testCount=$(eval "echo \${${itemPointer}[4]}")
  local testDesc=$(eval "echo \${${itemPointer}[5]}")
  local flushOutputIndex=$(eval "echo \${${itemPointer}[6]}")
  declare -a -g outputForTestingPointer=(
    "${testState}"
    "${testName}"
    "${testNameLen}"
    "${testCount}"
    "${testDesc}"
  )
  local encodeStr=$(listEncode "outputForTestingPointer")
  globalOutputStr=$( getOutputForTesting "${encodeStr}")

  updateOutput "${flushOutputIndex}" 'globalOutputStr'
}

##
# to get a length of history output for testing.
# @use getHistoryOutputLengthForTesting
# @echo <int>
#
function getHistoryOutputLengthForTesting() {
  echo "${#_globalIndexListForFlushOutput[@]}"
}

##
# to get a item of history output for testing.
# @use getHistoryOutputForTestingItemByIndex "<index>" "<point>"
# @echo <void>
##
function getHistoryOutputForTestingItemByIndex() {
  local index=$1
  local pointer=$2
  eval "declare -g -a ${pointer}=()"
  local encodeOutputStr="${_globalIndexListForFlushOutput[$index]}"
  eval " listDecode '${encodeOutputStr}' '${pointer}' "
}
