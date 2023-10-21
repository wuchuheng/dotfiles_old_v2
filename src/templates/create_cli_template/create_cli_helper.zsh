#!/usr/bin/env zsh

import ../../utils/helper.zsh # {get_all_sub_dir_by_path, split_str_with_point}

##
# get the max number from file names belong a directory
# @Use _getMaxNumber "<directory path>"
# @Example: _getMaxNumber "${APP_BASE_PATH}/src/cli"
# @return <number>
##
function _getMaxNumber() {
  local DIRECTORY_PATH=$1
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
# check the directory is exist or create
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

echo "Installing ${cliName} CLI cli tool..."
# Write installation example code here
EOF
  log ' CREATE' "${providerFile:${#APP_BASE_PATH} + 1}"
}

##
# init the directory
# @Use _initCLIDirectory "<cli name>" "<out put cli path>" "<out put installation provider path>" "<out put uninstallation provider path>"
##
function _initCLIDirectory() {
  local CLI_NAME=$1
  local CLI_PATH=$(getCliPath)
  local G_CLI_PATH_NAME=$2
  local G_INSTALLATION_PROVIDER_PATH_NAME=$3
  local G_UNINSTALLATION_PROVIDER_PATH_NAME=$4

  if [[ ! -d "${CLI_PATH}" ]]; then
    mkdir -p "${CLI_PATH}"
  fi
  _getMaxNumber "${CLI_NAME}"; local newCliNumber=$(( $? + 1 ))
  local CLI_PATH=${CLI_PATH}/${newCliNumber}_${CLI_NAME}_cli
  local INSTALLATION_PROVIDER_PATH=${CLI_PATH}/${CLI_NAME}_cli_installation_provider
  local UNINSTALLATION_PROVIDER_PATH=${CLI_PATH}/${CLI_NAME}_cli_uninstallation_provider
  _checkDirectoryOrCreate "${INSTALLATION_PROVIDER_PATH}"
  _checkDirectoryOrCreate "${UNINSTALLATION_PROVIDER_PATH}"

  eval "
      ${G_CLI_PATH_NAME}=${CLI_PATH}
      ${G_INSTALLATION_PROVIDER_PATH_NAME}='${INSTALLATION_PROVIDER_PATH}'
      ${G_UNINSTALLATION_PROVIDER_PATH_NAME}='${UNINSTALLATION_PROVIDER_PATH}'
  "
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
  log ' CREATE' "${cliBootLoaderFile:${#APP_BASE_PATH} + 1}"
}

##
# generate the provider file to uninstall the cli
# @Use _generateUninstallationProviderFile "<cli uninstallation provider file path>" "<cli name>"
# @return <boolean>
function _generateUninstallationProviderFile() {
  local cliUninstallationProviderFile=$1
  local CLI_NAME=$2
  cat > "$cliUninstallationProviderFile" << EOF
#!/usr/bin/env zsh

echo "Uninstalling $CLI_NAME CLI tool..."
# Write uninstallation example code here

EOF
  log ' CREATE' "${cliUninstallationProviderFile:${#APP_BASE_PATH} + 1}"
}

##
# crete cli
# @Use create_cli "<cli name>"
# @Echo <boolean>
##
function create_cli() {
  local CLI_NAME=$1

  _initCLIDirectory "${CLI_NAME}" "G_CLI_PATH" "G_INSTALLATION_PROVIDER_PATH" "G_UNINSTALLATION_PROVIDER_PATH"
  local CLI_PATH=${G_CLI_PATH}
  local INSTALLATION_PROVIDER_PATH=${G_INSTALLATION_PROVIDER_PATH}
  local UNINSTALLATION_PROVIDER_PATH=${G_UNINSTALLATION_PROVIDER_PATH}

  # Generate the cli installation provider file
  local cliInstallationProviderFile=${INSTALLATION_PROVIDER_PATH}/${CLI_NAME}_cli_installation_provider.zsh
  _generateInstallationProvider "${cliInstallationProviderFile}" "${CLI_NAME}"

  # Generate the bootloader file for cli.
  local cliBootLoaderFile=${CLI_PATH}/${CLI_NAME}_cli_bootloader.zsh
  _generateCLIBootloaderFile "${cliBootLoaderFile}" "${CLI_NAME}"

  # Generate the cli uninstallation provider file
  local cliUninstallationProviderFile=${UNINSTALLATION_PROVIDER_PATH}/${CLI_NAME}_cli_installation_provider.zsh
  _generateUninstallationProviderFile "${cliUninstallationProviderFile}" "${CLI_NAME}"
}