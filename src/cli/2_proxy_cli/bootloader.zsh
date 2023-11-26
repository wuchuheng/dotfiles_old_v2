#!/usr/bin/env zsh

# This is the entry file for proxy CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}
import @/src/utils/ref_variable_helper.zsh # {assign_str_to_ref, generate_unique_var_name,get_list_from_ref }
import @/src/utils/log.zsh #{log}
import @/src/utils/cli_helper.zsh #{load_cli_from_command_config}

function proxy_cli_boot() {
  load_all_cli_from_boot_config 'proxy'
}

