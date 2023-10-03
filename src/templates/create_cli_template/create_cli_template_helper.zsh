#!/usr/bin/env zsh


##
# get the cli name from command line.
# @Use get_input_cli_name <CLI_NAME_REF>
# @Echo <string>
##
function get_input_cli_name() {
  local CLI_NAME_REF=$1
  echo -n "Please enter the name of cli tools you want to create: "
  eval " read ${CLI_NAME_REF}"
  eval "${CLI_NAME_REF}=\$(echo \$${CLI_NAME_REF} | sed -E 's/ +/_/g')"
}
