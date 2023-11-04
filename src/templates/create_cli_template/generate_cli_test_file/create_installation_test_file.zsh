#!/usr/bin/env zsh

import ../generate_cli_common_helper_file.zsh # {generateCLICommonHelperFile, get_cli_name_from_number_cli_name}
import ../generate_cli_common_helper_file.zsh # {generateCLICommonHelperFile, get_cli_name_from_number_cli_name}
import @/src/utils/log.zsh # {log}

##
# get the installation test file
# @param $1 the number cli name
# @param $2 the output file ref
# @use get_installation_test_file <numCliName> <out put file ref>
# @
function get_installation_test_file() {
  local numberCliName=$1
  local outputFileRef=$2
  local numberCliName=$1
  local cliPath=$(getCliPath)

  local cliNameRefName=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${numberCliName}" "${cliNameRefName}"

  local installationTestFile=${cliPath}/${numberCliName}/__test__/installation_tests/1_installation.test.zsh
  if [[ ! -d "$(dirname ${installationTestFile})" ]]; then
    mkdir -p "$(dirname ${installationTestFile})"
  fi
  assign_str_to_ref "${installationTestFile}" "${outputFileRef}"
}

##
# create a test file for the installation
# @param $1 the number cli name
# @use create_installation_test_file <number_cli_name>
# @return <boolean>
##
function create_installation_test_file() {
  local numberCliName=$1
  local installationTestFileRef=$(generate_unique_var_name)
  get_installation_test_file "${numberCliName}" "${installationTestFileRef}"
  local installationTestFile=$(get_str_from_ref "${installationTestFileRef}")

  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${numberCliName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  local testFuncName="${cliName}_installation_test"
  cat > "${installationTestFile}" << EOF
#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}

function ${testFuncName}() {
  except_str "1"  "1"
}

testing_callback_handle "${testFuncName}" "test ${testFuncName}"

EOF

  log ' CREATE' "${installationTestFile:${#APP_BASE_PATH} + 1}"
}
