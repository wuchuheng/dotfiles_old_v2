#!/usr/bin/env zsh

import ../../utils/helper.zsh # {get_all_sub_dir_by_path, split_str_with_point}
import ../../utils/list_helper.zsh # {join}
import ../../utils/log.zsh # {log}
import ./generate_cli_common_helper_file.zsh # {generateCLICommonHelperFile, get_cli_name_from_number_cli_name}
import ./generate_cli_test_file/create_installation_test_file.zsh #{create_installation_test_file}
import ./generate_cli_test_file/create_uninstallation_test_file.zsh #{create_uninstallation_test_file}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, assign_str_to_ref, get_str_from_ref}
import @/src/utils/cli_helper.zsh #{get_cli_name_by_number_cli_dir, get_cli_path_by_name }
import @/src/utils/debug_helper.zsh #{assert_not_empty}

##
# get the max number from file names belong a directory
# @Use _getMaxNumber "<directory path>"
# @Example: _getMaxNumber "${APP_BASE_PATH}/src/cli"
# @return <number>
##
function _getMaxNumber() {
  local MAX_NUMBER=0
  local cliPath=$(getCliPath)
  local directoryList=($(get_all_sub_dir_by_path "${cliPath}"))
  if [[ ${#directoryList[@]} -gt 0 ]];then
    for el in ${directoryList}; do
      globalListReferenceName=()
      split_str_with_point "${el}" "_" "globalListReferenceName"
      local cliNO=${globalListReferenceName[1]}
      if (( ${cliNO} > ${MAX_NUMBER} )); then
        MAX_NUMBER=${cliNO}
      fi
    done
  fi
  return "${MAX_NUMBER}"
}

##
# check the directory is existed or create
# @Use _checkDirectoryOrCreate "<directory path>"
# @return <boolean>
##
function _checkDirectoryOrCreate() {
  local directoryPath=$1
  if [[ ! -d "${directoryPath}" ]]; then
     mkdir -p "${directoryPath}"
    if [[ $? -eq ${TRUE} ]]; then
      return "${TRUE}"
    else
      return "${FALSE}"
    fi
    else
      return "${FALSE}"
  fi
}

##
# generate the cli installation provider file
# @Use _generateInstallationProvider "<provider file>" "<cli name>"
# @Return <boolean>
##
function _generateInstallationProvider() {
  local providerFile=$1
  local cliName=$2
  cat > "${providerFile}" << EOF
#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to install ${cliName} cli
# @return <boolean>
##
function ${cliName}_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to \${TRUE}
  local isInstallBrokenRef=\$1

  log DEBUG "Installing ${cliName} CLI cli tool..."

  return "\${TRUE}"
}

EOF
  log ' CREATE' "${providerFile:${#APP_BASE_PATH} + 1}"
}

##
# get the cli installation checker provider file path
# @Use get_cli_check_install_file_path "<cli directory>" "<resultStrRef>"
# @Example  get_cli_check_install_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_check_install/tmp_cli_check_install.zsh>"
# @Return <boolean>
##
function get_cli_check_install_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/check_install/check_install.zsh
  assign_str_to_ref "${result}" "${outputResultRefName}"

  return "${TRUE}"
}

##
# get the cli uninstallation provider file path
# @Use get_cli_uninstaller_file_path "<cli directory>" "<resultStrRef>"
# @Example get_cli_uninstaller_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_uninstaller/tmp_cli_uninstaller.zsh>"
# @Return <boolean>
function get_cli_uninstaller_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/uninstaller/uninstaller.zsh
  assign_str_to_ref "${result}" "${outputResultRefName}"

  return "${TRUE}"
}

##
# get the file path of installation provider.
# @Use get_cli_installer_file_path "<cli directory>" "<resultStrRef>"
# @Example get_cli_installer_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_installer/tmp_cli_installer.zsh>"
# @Return <boolean>
##
function get_cli_installer_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local cliNameRefName=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${cliDirectory}" "${cliNameRefName}"
  local cliName=$(get_str_from_ref "${cliNameRefName}")

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/installer/installer.zsh
  assign_str_to_ref "${result}" "${outputResultRefName}"

  return "${TRUE}"
}

##
# init the directory
# @Use _initCLIDirectory "<cli name>" "<out put cli path>"
##
function _initCLIDirectory() {
  local CLI_NAME=$1
  local numberCliNameRefName=$2

  # init CLI directory.
  local CLI_PATH=$(getCliPath)
  if [[ ! -d "${CLI_PATH}" ]]; then
    mkdir -p "${CLI_PATH}"
  fi

  _getMaxNumber "${CLI_NAME}"; local newCliNumber=$(( $? + 1 ))
  local CLI_DIR_NAME=${newCliNumber}_${CLI_NAME}_cli

  # check the directory to save the provider to install.
  local installationProviderFilePathRefName=$(generate_unique_var_name)
  get_cli_installer_file_path "${CLI_DIR_NAME}" "${installationProviderFilePathRefName}"
  local installationProviderFilePath=$(get_str_from_ref "${installationProviderFilePathRefName}")
  local installer_PATH=$(dirname ${installationProviderFilePath})
  _checkDirectoryOrCreate "${installer_PATH}"

  # check the directory to save the uninstallation provider
  local uninstallationProviderFilePathRefName=$(generate_unique_var_name)
  get_cli_uninstaller_file_path "${CLI_DIR_NAME}" "${uninstallationProviderFilePathRefName}"
  local uninstallationProviderFilePath=$(get_str_from_ref "${uninstallationProviderFilePathRefName}")
  local UNinstaller_PATH=$(dirname ${uninstallationProviderFilePath})
  _checkDirectoryOrCreate "${UNinstaller_PATH}"

  # check the directory to save the installation checker provider
  local checkerFilePathRefName=$(generate_unique_var_name)
  get_cli_check_install_file_path "${CLI_DIR_NAME}" "${checkerFilePathRefName}"
  local checkerFilePath=$(get_str_from_ref "${checkerFilePathRefName}")
  local CHECK_INSTALL_PATH=$(dirname ${checkerFilePath})
  _checkDirectoryOrCreate "${CHECK_INSTALL_PATH}"

  assign_str_to_ref "${CLI_DIR_NAME}" "$numberCliNameRefName"
}

##
# generate the cli bootloader file
# @Use _generateCLIBootloaderFile "<cli bootloader file path>" "<cli name>"
# @return <boolean>
##
function _generateCLIBootloaderFile() {
  local cliBootLoaderFile=$1
  local cliName=$2
  cat > "$cliBootLoaderFile" << EOF
#!/usr/bin/env zsh

# This is the entry file for ${cliName} CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}

function ${cliName}_cli_boot() {
  alias ${cliName}='echo "hello ${cliName}"'
  log INFO "${cliName} cli loaded."
}

EOF
  log ' CREATE' "${cliBootLoaderFile:${#APP_BASE_PATH} + 1}"
}

##
# generate the provider file to uninstall the cli
# @Use _generateUninstallationProviderFile "<cli uninstallation provider file path>" "<cli name>"
# @return <boolean>
function _generateUninstallationProviderFile() {
  local cliUninstallationProviderFile=$1
  local cliName=$2
  cat > "$cliUninstallationProviderFile" << EOF
#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to uninstall ${cliName} cli
# @return <boolean>
##
function ${cliName}_cli_uninstaller() {
  log INFO "Uninstalling ${cliName} CLI cli tool..."
  unalias "${cliName}"

  return "\${TRUE}"
}

EOF
  log ' CREATE' "${cliUninstallationProviderFile:${#APP_BASE_PATH} + 1}"
}

##
# generate the provider file to check the cli is installed or not.
# @Use _generateInstallationCheckerProviderFile "<cli installation checker provider path>" "<cli name>"
# @return <boolean>
##
function _generateInstallationCheckerProviderFile() {
  local installationCheckerProviderFile=$1
  local CLI_NAME=$2
  cat > "$installationCheckerProviderFile" << EOF
#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/load_env.zsh #{get_env}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_str_from_ref}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, }

##
# check the cli ${CLI_NAME} was installed or not.
# @Use ${CLI_NAME}_installation_checker
# @Return <boolean>
##
function ${CLI_NAME}_cli_installation_checker() {
  log DEBUG "Checking if $CLI_NAME CLI tool was installed or not."
  local currentCliPathRef=\$(generate_unique_var_name)
  get_current_cli_path "\${currentCliPathRef}"
  local currentCliPath=\$(get_str_from_ref "${currentCliPathRef}") # /..../src/cli/${CLI_NAME}
  local envType=\$(get_env_type)
  case \$envType in
      prod)
        return "\${TRUE}"
      ;;
      install)
        return "\${FALSE}"
      ;;
      uninstall)
        return "\${TRUE}"
      ;;
      *)
        return "\${TRUE}"
      ;;
  esac
}
EOF
  log ' CREATE' "${installationCheckerProviderFile:${#APP_BASE_PATH} + 1}"

  return "${TRUE}"
}

##
# get the file path of bootloader for cli.
# @Use get_cli_boot_file_path "<cli directory>" "<resultStrRef>"
# @Return <boolean>
##
function get_cli_boot_file_path() {
  local numberCliName=$1
  local bootFileRefName=$2
  local cliBootLoaderFile=$(getCliPath)/${numberCliName}/bootloader.zsh

  assign_str_to_ref "${cliBootLoaderFile}" "${bootFileRefName}"

  return "${TRUE}"
}

##
# create a cli runtime directory
# @use create_cli_runtime_dir <numCliDir>
##
function create_cli_runtime_dir() {
  assert_not_empty "$1"
  local numCliDir="$1"
  # get cli name
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numCliDir}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  # get the cli path for the current cli
  local cliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${cliName:0:-4}" "${cliPathRef}"
  local cliPath=$(get_str_from_ref "${cliPathRef}")
  assert_not_empty "${cliPath}"

  # create the runtime directory for cli
  local cliRuntimeDir="$(getCliRuntimeDirectory)/${cliName}"
  if [[ ! -d ${cliRuntimeDir} ]]; then
    mkdir -p "${cliRuntimeDir}"
  fi

  # get the path level count between ${cliPath} to the dotfiles root path
  local relativeCliRuntimeDir=${cliRuntimeDir:${#APP_BASE_PATH} + 1}
  local levelFromCliPathToRoot=0;
  local levelFromCliPathToRootCountRef=$(generate_unique_var_name);
  split_str_with_point "${cliPath:${#APP_BASE_PATH} + 1}" "/" "${levelFromCliPathToRootCountRef}"
  local levelFromCliPathToRootCount=$(get_str_from_ref "${levelFromCliPathToRootCountRef}")
  levelFromCliPathToRootSlice=($(get_list_from_ref "${levelFromCliPathToRootCountRef}"))
  levelFromCliPathToRootCount=${#levelFromCliPathToRootSlice[@]}

  # get generate the path to link from ${cliPath} to cli_runtime
  local linkPath=''
  local i
  for (( i = 0; i < ${levelFromCliPathToRootCount}; i++ )); do
    linkPath="../${linkPath}"
  done
  assert_not_empty "${linkPath}"
  linkPath="${linkPath}${relativeCliRuntimeDir}"

  # link the runtime of the cli to the root directory of the cli.
  ln -s "${linkPath}" "${cliPath}/runtime"
  if [[ $? -eq ${TRUE} ]] ; then
    log INFO " CREATE the runtime path for ${cliName:0:-4} cli"
  else
    log ERROR " CREATED failed the runtime path for ${cliName:0:-4} cli"
  fi
}

##
# crete cli
# @Use create_cli "<cli name>"
# @Echo <boolean>
##
function create_cli() {
  local CLI_NAME=$1
  local numberCliNameRefName=$(generate_unique_var_name)
  _initCLIDirectory "${CLI_NAME}" "${numberCliNameRefName}"

  local numberCliName=$(get_str_from_ref "${numberCliNameRefName}")

  # Generate the cli installation provider file
  local cliInstallationProviderFileRef=$(generate_unique_var_name)
  get_cli_installer_file_path "${numberCliName}" "${cliInstallationProviderFileRef}"
  local cliInstallationProviderFile=$(get_str_from_ref "${cliInstallationProviderFileRef}")
  _generateInstallationProvider "${cliInstallationProviderFile}" "${CLI_NAME}"

  # Generate the bootloader file for cli.
  local cliBootLoaderFileRef=$(generate_unique_var_name)
  get_cli_boot_file_path "${numberCliName}" "${cliBootLoaderFileRef}"
  local cliBootLoaderFile=$(get_str_from_ref "${cliBootLoaderFileRef}")
  _generateCLIBootloaderFile "${cliBootLoaderFile}" "${CLI_NAME}"

  # Generate the cli uninstallation provider file
  local cliUninstallationProviderFileRefName=$(generate_unique_var_name)
  get_cli_uninstaller_file_path "${numberCliName}" "${cliUninstallationProviderFileRefName}"
  local cliUninstallationProviderFile=$(get_str_from_ref "${cliUninstallationProviderFileRefName}")
  _generateUninstallationProviderFile "${cliUninstallationProviderFile}" "${CLI_NAME}"

  # Generate the cli installation checker provider file.
  local cliInstallationCheckerProviderFileRef=$(generate_unique_var_name)
  get_cli_check_install_file_path "${numberCliName}" "${cliInstallationCheckerProviderFileRef}"
  local cliInstallationCheckerProviderFile=$(get_str_from_ref "${cliInstallationCheckerProviderFileRef}")
  _generateInstallationCheckerProviderFile "${cliInstallationCheckerProviderFile}" "${CLI_NAME}"

  # generate the cli_common_helper file.
  generateCLICommonHelperFile "${numberCliName}"

  # create the installation test
  create_installation_test_file "${numberCliName}"

  # create the uninstallation test
  create_uninstallation_test_file "${numberCliName}"

  # create the runtime directory for the new cli
  create_cli_runtime_dir "${numberCliName}"
}