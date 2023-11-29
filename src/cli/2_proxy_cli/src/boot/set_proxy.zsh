#!/usr/bin/env zsh
##
# set the proxy in terminal
# @author wuchuheng<root@wuchuheng.com>
# @date   2023-11-29 17:06
##

#
# env config
# @param APP_BASE_PATH {string} a path of app
##
source "${APP_BASE_PATH}/src/utils/autoload.zsh" || exit 1

import ../../common_helper.zsh #{print_proxy_command}
import @/src/utils/log.zsh #{log}

local cliStr=$(print_proxy_command)
eval "${cliStr}"

if [[ $? -eq "${TRUE}" ]]; then
  log INFO "${cliStr}"
  exit 0
else
  log ERROR "Proxy service startup failure in shell."
  exit 1
fi

