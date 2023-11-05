#!/usr/bin/env zsh

##
# This script is used to uninstall all cli
# @Author wuchuheng<root@wuchuheng.com>
# @Date 2023/11/05 13:13
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

get_OS_symbol
