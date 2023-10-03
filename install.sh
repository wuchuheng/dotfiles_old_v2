#!/usr/bin/env bash

source $(pwd)/src/vendor/dotfile_bash_module/src/lib.sh || exit 1

import ./src/vendor/dotfile_bash_module/src/utils/helper.sh
import ./src/vendor/dotfile_bash_module/src/utils/log.sh # import utils
import ./src/vendor/dotfile_bash_module/src/common/install/install_all_cli.sh
import ./src/vendor/dotfile_bash_module/src/common/install/to_push_config_to_env.sh
import ./src/vendor/dotfile_bash_module/src/common/install/init.sh

#echo $DOTFILES_BASE_PATH
VERSION_NUMBER="1.0.0"
IS_FORCE_INSTALLATION=false

# Parse command line options
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help)
      import ./src/vendor/dotfile_bash_module/src/common/install/documentation.sh
      exit 0
    ;;
    -v|--version)
      log "SUCCESS"  "Profiles project version $VERSION_NUMBER"
      exit 0
    ;;
    -f|--force)
      IS_FORCE_INSTALLATION=true
      shift
    ;;
    *)
      log "SUCCESS"  "Invalid option: $1"
      exit 1
    ;;
esac
done

IS_INSTALL_LOG_PATH=$DOTFILES_BASE_PATH/src/runtime/logs/is_install_log.sh
if [ -f $IS_INSTALL_LOG_PATH ]  && [ $IS_FORCE_INSTALLATION != true ]; then
    log "ERROR" "The installation failed because the project has already been installed previously."
    exit 1;
fi

# Mark Installed
echo $(date +"%Y-%m-%d %T") > $IS_INSTALL_LOG_PATH

init_main_zsh

# To install all cli
to_install_all_cli

# Add bootstrap configuration.
to_push_config_to_env

if [ $? == 0 ]; then
  log "INFO" "To launching zsh"
  log "SUCCESS" "Install sucessfully"
  zsh
fi
