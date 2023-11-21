#!/usr/bin/env zsh

import ../generate_cli_common_helper_file.zsh # {generateCLICommonHelperFile}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name} #{get_str_from_ref} # {assign_str_to_ref}
import @/src/utils/log.zsh #{log}
import @/src/utils/cli_helper.zsh # {get_cli_name_by_number_cli_dir}

##
# get the uninstallation test file
# @param $1 the number cli name
# @param $2 the output file ref
# @use get_uninstallation_test_file <numCliName> <out put file ref>
# @
function get_uninstallation_test_file() {
  local numberCliName=$1
  local outputFileRef=$2
  local numberCliName=$1
  local cliPath=$(getCliPath)

  local uninstallationTestFile=${cliPath}/${numberCliName}/__test__/uninstallation_tests/1_uninstallation.test.zsh
  if [[ ! -d "$(dirname ${uninstallationTestFile})" ]]; then
    mkdir -p "$(dirname ${uninstallationTestFile})"
  fi
  assign_str_to_ref "${uninstallationTestFile}" "${outputFileRef}"
}

##
# create a test file for the uninstallation
# @param $1 the number cli name
# @use create_uninstallation_test_file <number_cli_name>
# @return <boolean>
##
function create_uninstallation_test_file() {
  local numberCliName=$1
  local uninstallationTestFileRef=$(generate_unique_var_name)
  get_uninstallation_test_file "${numberCliName}" "${uninstallationTestFileRef}"
  local uninstallationTestFile=$(get_str_from_ref "${uninstallationTestFileRef}")

  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numberCliName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  local testFuncName="${cliName}_uninstallation_test"
  cat > "${uninstallationTestFile}" << EOF
#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}

function ${testFuncName}() {
  except_str "1"  "1"
}

testing_callback_handle "${testFuncName}" "test ${testFuncName}"

EOF

  log ' CREATE' "${uninstallationTestFile:${#APP_BASE_PATH} + 1}"
}