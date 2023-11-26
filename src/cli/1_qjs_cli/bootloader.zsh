#!/usr/bin/env zsh

# This is the entry file for qjs CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, get_str_from_ref}
import ./common_helper.zsh #{get_qjs_bin}
import @/src/utils/cli_helper.zsh #{get_current_cli_name, get_current_cli_path, load_cli_from_command_config}
import @/src/utils/debug_helper.zsh # {assert_not_empty}

function qjs_cli_boot() {
  load_all_cli_from_boot_config 'qjs'
}
