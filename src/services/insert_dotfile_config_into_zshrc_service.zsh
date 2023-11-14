#!/usr/bin/env zsh

typeset -g globalStartOfDotfileConfSymbol='# Start of dotfile configuration'
typeset -g globalEndOfDotfileConfSymbol='# End of dotfile configuration'

##
# check if dotfile config is in zsh script
# @Use checkIfDotfileConfigIsInZshrcService
# @Return <boolean>
##
function checkIfDotfileConfigIsInZshrcService() {
  local zshrcFile=~/.zshrc
  if [[ ! -f ${zshrcFile} ]]; then
    touch ${zshrcFile}
  fi
  local configText=$(awk "/${globalStartOfDotfileConfSymbol}/,/${globalEndOfDotfileConfSymbol}/" ${zshrcFile})
  # if the config text is empty, then the config is not in the zshrc file
  if [[ -z ${configText} ]]; then
    return ${FALSE}
  else
    return ${TRUE}
  fi
}

##
# remove the dotfile config from ~/.zshrc
# @Use removeDotfileConfigFromZshrcService
# @Return <boolean>
##
function removeDotfileConfigFromZshrcService() {
  local zshrcFile='~/.zshrc'
  eval " sed -i '' '/${globalStartOfDotfileConfSymbol}/,/${globalEndOfDotfileConfSymbol}/d' ${zshrcFile} "

  if [[ $? -eq 0 ]]; then
    return ${TRUE}
  else
    return ${FALSE}
  fi
}

##
# Insert the dotfile configuration into
# @Use insertDotfileConfigIntoZshrcService
# @Return <boolean>
##
function insertDotfileConfigIntoZshrcService() {
  checkIfDotfileConfigIsInZshrcService
  local isConfigExist=$?
  if [[ ${isConfigExist} -eq ${TRUE} ]]; then
    removeDotfileConfigFromZshrcService
  fi
  local zshrcFile=~/.zshrc

  cat >> "${zshrcFile}" << EOF

${globalStartOfDotfileConfSymbol}
typeset -g APP_BASE_PATH="${APP_BASE_PATH}"
if [[ -d \${APP_BASE_PATH} ]]; then
  source "\${APP_BASE_PATH}"/src/bootstrap/dotfile_boot.zsh
fi
${globalEndOfDotfileConfSymbol}
EOF

}