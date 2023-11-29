#!/usr/bin/env zsh
##
# start the proxy service
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

local cmd=$(print_proxy_command)

echo "${cmd}"
