#!/usr/bin/env zsh

assert_not_empty() {
  if [[ -z "$1" ]]; then
    throw "${1:-the variable is empty}" 2
  fi
}

##
# check 2 arguments are equal
#
assert_equal() {
  local arg1=$1
  local arg2=$2
  if [[ ${arg1} != ${arg2} ]]; then
    throw "arg1: ${arg1} is not equal to arg2: ${arg2}" 2
  fi
}
