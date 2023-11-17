#!/usr/bin/env zsh

# This is the entry file for qjs CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, get_str_from_ref}
import ./common_helper.zsh #{get_qjs_bin}
import @/src/utils/cli_helper.zsh #{get_current_cli_name, get_current_cli_path}

function qjs_cli_boot() {
    local currentCliPathRef=$(generate_unique_var_name)
    get_current_cli_path "${currentCliPathRef}"
    local currentCliPath=$(get_str_from_ref "${currentCliPathRef}")
    local qjsBinRef=$(generate_unique_var_name)
    get_qjs_bin "${qjsBinRef}"
    local qjsBin=$(get_str_from_ref "${qjsBinRef}")

    if [[ -f "${qjsBin}" ]]; then
      alias qjs="${qjsBin}"
      log INFO "qjs cli loaded"
      alias base64Decode="${qjsBin} ${currentCliPath}/src/base64decode.mjs"
      log INFO "base64Decode cli loaded"
    else
      log ERROR "Failed to load qjs,the qjs bin ${qjsBin:${#APP_BASE_PATH} + 1} not found"
    fi
}

