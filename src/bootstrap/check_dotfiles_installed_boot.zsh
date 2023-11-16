#!/usr/bin/env zsh

##
# The bootloader to check the all cli was installed or not
#
# @User wuchuheng<root@wuchuheng.com>
# @Date 2023-11-13 20:01
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_uninstallation_provider_file_path}
import ./boot_helper.zsh # { check_cli_by_number_dir }
import @/src/services/insert_dotfile_config_into_zshrc_service.zsh #{checkIfDotfileConfigIsInZshrcService}
import @/src/utils/cli_helper.zsh #{getCliDirList}
import @/src/utils/load_env.zsh # {set_env_type}
import @/src/utils/color_printf.zsh # {red_print, green_print}
set_env_type 'check_installation'


# get the cli list from cli directory.
local cliDirListRef=$(generate_unique_var_name)
getCliDirList ${cliDirListRef}
local cliDirList=($(get_str_from_ref "${cliDirListRef}"));

totalCliNum="${#cliDirList[@]}"
totalSuccessfulCliNum=0
totalFailedCliNum=0
printf "Check all cli was installed or not:\n"
# to trigger the installation provider from cli dir
for numberCliDirName in "${cliDirList[@]}"; do
  # check the cli is installation or not.
  check_cli_by_number_dir "${numberCliDirName}"
  local isInstallation=$?
  # if the cli was not installed, then install it.
  if [[ "${isInstallation}" -eq "${TRUE}" ]]; then
    printf "${numberCliDirName}: SUCCESSFUL\n"
    (( totalSuccessfulCliNum++ ))
  else
    printf "${numberCliDirName}: FAILED\n"
    (( totalFailedCliNum++ ))
  fi
done


# Print the summer of installation for all cli
printf "\nTotal cli: ${totalCliNum}\n"
printf "Successful installed  cli: $(green_print ${totalSuccessfulCliNum}) \n"
printf "Failed installed cli: $(red_print ${totalFailedCliNum})\n"

if [[ ${totalFailedCliNum} -gt 0 ]]; then
  exit 1
fi

printf "Check the dotfiles was existed or not in .zshrc\n"
checkIfDotfileConfigIsInZshrcService
if [[ $? -eq 0 ]]; then
  printf "$(green_print PASS)\n"
else
  printf "$(red_print FAILED)\n"
  exit 1
fi