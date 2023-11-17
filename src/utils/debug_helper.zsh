#!/usr/bin/env zsh

assert_not_empty() {
  if [[ -z "$1" ]]; then
    throw "${1:-the variable is empty}" 2
  fi
}

