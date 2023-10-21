#!/usr/bin/env zsh

# initialize globalFlushOutput to store all output string.
if [[ -z "$globalFlushOutput" ]]; then
  declare -g globalFlushOutput=()
fi

function _flush() {
  local output=""
  for (( i = 1; i <= ${#globalFlushOutput}; i++ )); do
    if (( i == 1 )); then
      output="${globalFlushOutput[${i}]}"
    else
      output="${output}\n${globalFlushOutput[${i}]}"
    fi
  done
  echo -ne "\033[10000A\r\033[K${output}"
#  echo "${output}"
}

##
# to flush a output in terminal for test
#
##
function pushToFlushOutput() {
  globalFlushOutput+=("$1")
  _flush
}

##
# to flush a output in terminal for test with pointer
# @Use pushToFlushOutputWithStrPointer '<strPointer>'
#
##
function pushToFlushOutputWithStrPointer() {
  local strPointer="$1"
  eval "
  globalFlushOutput+=("\$${strPointer}")
  "
  _flush
}

##
# update multiple outputToFlushOutput
#
##
function updateMultipleOutputToFlushOutput() {
  local indexMapItemPoint=$1
  eval "
  for key value in \${(kv)$indexMapItemPoint}; do
      echo \"Key: \$key, Value: \$value\"
  done
  "
}

##
# get the length of output.
# @use getFlushOutputLength
# @echo <int>
##
function getFlushOutputLength() {
  echo ${#globalFlushOutput}
}

##
# update output with index and new item.
# @use updateOutput <index> "<changedItemPointer>"
# @echo <void>
##
function updateOutput() {
  local index="$1"
  local changedItemPointer="$2"
  eval "
    globalFlushOutput[\${index}]=\"\${${changedItemPointer}}\"
  "
  _flush
}