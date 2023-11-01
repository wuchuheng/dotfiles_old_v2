#!/usr/bin/env zsh

import ../../utils/helper.zsh # {get_all_sub_dir_by_path, split_str_with_point}
import ../../utils/list_helper.zsh # {join}
import ../../utils/log.zsh # {log}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, assign_str_to_ref, get_str_from_ref}

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
function ${cliName}_installation_provider() {
  log INFO "Installing ${cliName} CLI cli tool..."

  return "\${TRUE}"
}

EOF
  log ' CREATE' "${providerFile}"
}

##
# get cli name from the cli directory that with a number.
# @Use get_cli_name_from_number_cli_name "<cli directory>" "<resultStrRef>"
# @Example get_cli_name_from_number_cli_name "1_tmp_cli" "<tmp_cli>"
# @Return "<boolean>"
##
function get_cli_name_from_number_cli_name() {
  local cliDirectory=$1
  local outputResultRefName=$2
  globalCliDirInfoListRef=()
  split_str_with_point  "${cliDirectory}" '_' globalCliDirInfoListRef
  # remove the first element of the globalCliDirInfoListRef
  globalCliDirInfoListRef=("${globalCliDirInfoListRef[@]:1}")

  globalCliNameTmp=''
  join '_' globalCliDirInfoListRef globalCliNameTmp

  local cliName=${globalCliNameTmp}
  assign_str_to_ref "${cliName}" "${outputResultRefName}"

  return "${TRUE}"
}


##
# get the cli installation checker provider file path
# @Use get_cli_installation_checker_provider_file_path "<cli directory>" "<resultStrRef>"
# @Example  get_cli_installation_checker_provider_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_installation_checker_provider/tmp_cli_installation_checker_provider.zsh>"
# @Return <boolean>
##
function get_cli_installation_checker_provider_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local cliNameRefName=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${cliDirectory}" "${cliNameRefName}"
  local cliName=$(get_str_from_ref "${cliNameRefName}")

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/${cliName}_installation_checker_provider/${cliName}_installation_checker_provider.zsh
  assign_str_to_ref "${result}" "${outputResultRefName}"

  return "${TRUE}"
}

##
# get the cli uninstallation provider file path
# @Use get_cli_uninstallation_provider_file_path "<cli directory>" "<resultStrRef>"
# @Example get_cli_uninstallation_provider_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_uninstallation_provider/tmp_cli_uninstallation_provider.zsh>"
# @Return <boolean>
function get_cli_uninstallation_provider_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local cliNameRefName=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${cliDirectory}" "${cliNameRefName}"
  local cliName=$(get_str_from_ref "${cliNameRefName}")

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/${cliName}_uninstallation_provider/${cliName}_uninstallation_provider.zsh
  assign_str_to_ref "${result}" "${outputResultRefName}"

  return "${TRUE}"
}

##
# get the file path of installation provider.
# @Use get_cli_installation_provider_file_path "<cli directory>" "<resultStrRef>"
# @Example get_cli_installation_provider_file_path "1_tmp_cli" "<1_tmp_cli/tmp_cli_installation_provider/tmp_cli_installation_provider.zsh>"
# @Return <boolean>
##
function get_cli_installation_provider_file_path() {
  local cliDirectory=$1
  local outputResultRefName=$2

  local cliNameRefName=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${cliDirectory}" "${cliNameRefName}"
  local cliName=$(get_str_from_ref "${cliNameRefName}")

  local CLI_PATH=$(getCliPath)
  local result=${CLI_PATH}/${cliDirectory}/${cliName}_installation_provider/${cliName}_installation_provider.zsh
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
  get_cli_installation_provider_file_path "${CLI_DIR_NAME}" "${installationProviderFilePathRefName}"
  local installationProviderFilePath=$(get_str_from_ref "${installationProviderFilePathRefName}")
  local INSTALLATION_PROVIDER_PATH=$(dirname ${installationProviderFilePath})
  _checkDirectoryOrCreate "${INSTALLATION_PROVIDER_PATH}"

  # check the directory to save the uninstallation provider
  local uninstallationProviderFilePathRefName=$(generate_unique_var_name)
  get_cli_uninstallation_provider_file_path "${CLI_DIR_NAME}" "${uninstallationProviderFilePathRefName}"
  local uninstallationProviderFilePath=$(get_str_from_ref "${uninstallationProviderFilePathRefName}")
  local UNINSTALLATION_PROVIDER_PATH=$(dirname ${uninstallationProviderFilePath})
  _checkDirectoryOrCreate "${UNINSTALLATION_PROVIDER_PATH}"

  # check the directory to save the installation checker provider
  local checkerFilePathRefName=$(generate_unique_var_name)
  get_cli_installation_checker_provider_file_path "${CLI_DIR_NAME}" "${checkerFilePathRefName}"
  local checkerFilePath=$(get_str_from_ref "${checkerFilePathRefName}")
  local INSTALLATION_CHECKER_PROVIDER_PATH=$(dirname ${checkerFilePath})
  _checkDirectoryOrCreate "${INSTALLATION_CHECKER_PROVIDER_PATH}"

  assign_str_to_ref "${CLI_DIR_NAME}" "$numberCliNameRefName"
}

##
# generate the cli bootloader file
# @Use _generateCLIBootloaderFile "<cli bootloader file path>" "<cli name>"
# @return <boolean>
##
function _generateCLIBootloaderFile() {
  local cliBootLoaderFile=$1
  local CLI_NAME=$2
  cat > "$cliBootLoaderFile" << EOF
#!/usr/bin/env zsh

# This is the entry file for ${CLI_NAME} CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file
alias ${CLI_NAME}='echo "hello ${CLI_NAME}"'
EOF
  log ' CREATE' "${cliBootLoaderFile}"
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
function ${cliName}_cli_uninstallation_provider() {
  log INFO "Uninstalling ${cliName} CLI cli tool..."

  return "\${TRUE}"
}

EOF
  log ' CREATE' "${cliUninstallationProviderFile}"
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

log INFO "Checking if $CLI_NAME CLI tool is installed..."

##
# check the cli ${CLI_NAME} was installed or not.
# @Use ${CLI_NAME}_installation_checker
# @Return <boolean>
##
function ${CLI_NAME}_cli_installation_checker() {

  return "\${TRUE}"
}
EOF
  log ' CREATE' "${installationCheckerProviderFile}"

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
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_from_number_cli_name "${numberCliName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")
  local cliBootLoaderFile=$(getCliPath)/${numberCliName}/${cliName}_cli_bootloader.zsh

  assign_str_to_ref "${cliBootLoaderFile}" "${bootFileRefName}"

  return "${TRUE}"
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
  get_cli_installation_provider_file_path "${numberCliName}" "${cliInstallationProviderFileRef}"
  local cliInstallationProviderFile=$(get_str_from_ref "${cliInstallationProviderFileRef}")
  _generateInstallationProvider "${cliInstallationProviderFile}" "${CLI_NAME}"

  # Generate the bootloader file for cli.
  local cliBootLoaderFileRef=$(generate_unique_var_name)
  get_cli_boot_file_path "${numberCliName}" "${cliBootLoaderFileRef}"
  local cliBootLoaderFile=$(get_str_from_ref "${cliBootLoaderFileRef}")
  _generateCLIBootloaderFile "${cliBootLoaderFile}" "${CLI_NAME}"

  # Generate the cli uninstallation provider file
  local cliUninstallationProviderFileRefName=$(generate_unique_var_name)
  get_cli_uninstallation_provider_file_path "${numberCliName}" "${cliUninstallationProviderFileRefName}"
  local cliUninstallationProviderFile=$(get_str_from_ref "${cliUninstallationProviderFileRefName}")
  _generateUninstallationProviderFile "${cliUninstallationProviderFile}" "${CLI_NAME}"

  # Generate the cli installation checker provider file.
  local cliInstallationCheckerProviderFileRef=$(generate_unique_var_name)
  get_cli_installation_checker_provider_file_path "${numberCliName}" "${cliInstallationCheckerProviderFileRef}"
  local cliInstallationCheckerProviderFile=$(get_str_from_ref "${cliInstallationCheckerProviderFileRef}")
  _generateInstallationCheckerProviderFile "${cliInstallationCheckerProviderFile}" "${CLI_NAME}"
}