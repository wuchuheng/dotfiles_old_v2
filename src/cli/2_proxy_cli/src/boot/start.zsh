#!/usr/bin/env zsh
##
# start the proxy service
# @author wuchuheng<root@wuchuheng.com>
# @date   2023-11-29 03:08
##

#
# env config
# @param APP_BASE_PATH {string} a path of app
# @param CLI_ROOT_PATH {string} a path of current cli
# @param DECODE_PROXY_CONF_VAL_CLI {string} a cli path to decode the proxy config
# @param PROXY_CLI {string} a cli path to start the proxy service
##
source "${APP_BASE_PATH}/src/utils/autoload.zsh" || exit 1

import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name}
import @/src/utils/log.zsh #{log}
import ../../common_helper.zsh #{get_success_proxy_log_file_path}
import @/src/utils/cli_helper.zsh #{get_cli_name_by_number_cli_dir}
import @/src/utils/debug_helper.zsh #{assert_not_empty}

##
# check the proxy service was started or not
# @use check_proxy_service_is_started
# @return {boolean} true: started, false: not started
##
function check_proxy_service_is_started() {
  local taskLineCount=$( ps aux | grep "${PROXY_CLI}" | wc -l )
  taskLineCount="${taskLineCount##*( )}"
  if [[ ${taskLineCount} -gt 1  ]]; then
    log INFO "proxy is start"
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}

##
# start the proxy service
# @use star_proxy_service
# @return <boolean>
##
function star_proxy_service() {
  local cliNameRef=$(generate_unique_var_name)
  local cliPath=$(getCliPath)
  local numberCliNameDir=${CLI_ROOT_PATH:${#cliPath} + 1}
  get_cli_name_by_number_cli_dir "${numberCliNameDir}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  local successLogFilePathRef=$(generate_unique_var_name)
  get_success_proxy_log_file_path "${cliName}" "${successLogFilePathRef}"
  local successLogFilePath=$(get_str_from_ref "${successLogFilePathRef}")

  local errorLogFilePathRef=$(generate_unique_var_name)
  get_error_proxy_log_file_path "${cliName}" "${errorLogFilePathRef}"
  local errorLogFilePath=$(get_str_from_ref "${errorLogFilePathRef}")

  local configFilePath="${CLI_ROOT_PATH}/runtime/config.json"
  # convert the variable name in the proxy config
  eval "\
    ${DECODE_PROXY_CONF_VAL_CLI} ${CLI_ROOT_PATH}/proxy_config.json5 \
     --ERROR_LOG_FILE_PATH ${errorLogFilePath} \
     --SUCCESSFUL_LOG_FILE_PATH ${successLogFilePath} \
     > ${configFilePath}"
  assert_cmd_ok
  eval "nohup ${PROXY_CLI} run -c ${configFilePath} > ${CLI_ROOT_PATH}/runtime/log/nohup.log 2>&1 &"
  assert_cmd_ok
}

check_proxy_service_is_started
if [[ $? -ne ${TRUE} ]]; then
  star_proxy_service
fi
return $?

