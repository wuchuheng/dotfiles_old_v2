#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/debug_helper.zsh # {assert_not_empty}
import @/src/utils/ref_variable_helper.zsh  # {assign_str_to_ref}

##
# get the os name like ubuntuOS, centOS or macOS
# @use get_os_name <output os name ref>
# @return <boolean>
get_os_name() {
  assert_not_empty "$1"
  local outputOSNameRef=$1
  local result=''
  case "$(uname -s)" in
    Linux*)
      if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [ "$ID" = "ubuntu" ]; then
          result="UbuntuOS"
        elif [ "$ID" = "centos" ]; then
          result="CentOS"
        fi
      fi
      ;;
    Darwin*)
      result="MacOS"
      ;;
  esac
  assert_not_empty "${result}"
  assign_str_to_ref "$result" "${outputOSNameRef}"
  if [[ -n ${result} ]]; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}
