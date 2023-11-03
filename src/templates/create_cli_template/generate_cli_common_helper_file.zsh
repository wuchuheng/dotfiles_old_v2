#!/usr/bin/env zsh

import ./get_func_name_helper.zsh #{get_func_name:get__runtime_space, get_func_name:set_key_map_value_for,get_func_name:set_key_map_value_with_ref_for, get_func_name:get_key_map_value_for, get_func_name:check_key_map_exists_for }
import @/src/utils/log.zsh #{log}

##
# generate the cli helper library file.
# @Use _generateCLICommonHelperFile <number cli name>
# @Return <boolean>
##
function generateCLICommonHelperFile() {
  local numberCliName=$1
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${numberCliName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")
  local cliHelperLibraryFile=$(getCliPath)/${numberCliName}/${cliName}_common_helper.zsh

  cat > "${cliHelperLibraryFile}" << EOF
#!/usr/bin/env zsh

import src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}

##
# get the cli runtime space.
# @Use get_tmp_runtime_space
# @Echo "<a directory path>"
##
function $(get_func_name:get__runtime_space ${cliName})() {
  local cliRuntimeDir="\$(getCliRuntimeDirectory)/${cliName}"
  if [[ ! -d \${cliRuntimeDir} ]]; then
    mkdir -p \${cliRuntimeDir}
  fi

  echo "\${cliRuntimeDir}"
}

##
# set key map value.
# @use set_key_map_value_for_tmp <key> <value>
# @Return <boolean>
##
function $(get_func_name:set_key_map_value_for ${cliName})() {
  local key="\${1}"
  local value=\$2
  local cacheSpaceName=\$(getCliRuntimeDirectory)/tmp

  setStringValue "\${key}" "\${value}" "\${cacheSpaceName}"

  return \$?
}

##
# set key map value with reference.
# @Use set_key_map_value_with_ref_for_tmp <key> <value ref>
# @Return <boolean>
##
function $(get_func_name:set_key_map_value_with_ref_for ${cliName})() {
  local key="\${1}"
  local valueRef=\$2
  local cacheSpaceName=\$(getCliRuntimeDirectory)/${cliName}

  setStringValueWithPointer "\${key}" "\${valueRef}" "\${cacheSpaceName}"

  return \$?
}

##
# get value with key for tmp cli
# @Use get_key_map_value_for_tmp <key>
# @Echo <value>
# @Return <boolean>
##
function $(get_func_name:get_key_map_value_for ${cliName})() {
  local key="\${1}"
  local cacheSpaceName=\$(getCliRuntimeDirectory)/${cliName}

  getStringValue "\${key}" "\${cacheSpaceName}"
  return \$?
}

##
# check the cache key exists or not.
# @Use check_key_map_exists_for_${cliName} <key>
# @Return <boolean>
##
function $(get_func_name:check_key_map_exists_for ${cliName})() {
  local key="\${1}"
  local cacheSpaceName=\$(getCliRuntimeDirectory)/${cliName}

  getStringValue "\${key}" "\${cacheSpaceName}"
  return \$?
}

EOF

  log CREATE "${cliHelperLibraryFile:${#APP_BASE_PATH} + 1}"
}
