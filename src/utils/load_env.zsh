#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# load env with env file path
# @Use load_env <env_file_path>
# @Return <boolean>
##
function load_env() {
  local env_file=$1
  if [ -f "$env_file" ]; then
    log INFO "Loading environment variables from $env_file"
    source "${env_file}"

    # if t variable is existed
    if [ -n "$RUNTIME_DIR" ]; then
      l_project_base_path=$(dirname "${env_file}")
      RUNTIME_DIR=${l_project_base_path}/${RUNTIME_DIR}
    fi

    return ${TRUE}
  else
    log INFO "Environment file $env_file not found"
    return ${FALSE}
  fi
}

##
# get env variable
# @Use get_env <env_var_name> <default_value>
# @Echo <env_var_value>
# @Return <boolean>
##
function get_env() {
  local env_var_name=$1
  local default_value=${2:-''}
  local env_var_value=$(eval echo \$$env_var_name)
  if [ -z "$env_var_value" ]; then
    echo "${default_value}"
    return "${FALSE}"
  else
    echo "${env_var_value}"
    return "${TRUE}"
  fi
}
