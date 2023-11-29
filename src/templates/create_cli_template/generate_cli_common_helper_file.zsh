#!/usr/bin/env zsh

import @/src/utils/log.zsh #{log}
import @/src/utils/cli_helper.zsh #{get_cli_name_by_number_cli_dir}

##
# generate the cli helper library file.
# @Use _generateCLICommonHelperFile <number cli name>
# @Return <boolean>
##
function generateCLICommonHelperFile() {
  local numberCliName=$1

  local cliHelperLibraryFile=$(getCliPath)/${numberCliName}/common_helper.zsh

  cat > "${cliHelperLibraryFile}" << EOF
#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}


EOF

  log ' CREATE' "${cliHelperLibraryFile:${#APP_BASE_PATH} + 1}"
}

