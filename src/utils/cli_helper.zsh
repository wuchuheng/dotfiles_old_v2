#!/usr/bin/env zsh

import ./helper.zsh # {get_all_sub_dir_by_path, split_str_with_point}
import ./list_helper.zsh # {join}
import ./ref_variable_helper.zsh # {assign_str_to_ref, generate_unique_var_name,get_list_from_ref }
import @/src/utils/debug_helper.zsh # {assert_not_empty}
import ./os_helper.zsh # {get_os_name}
import @/src/utils/swap_helper.zsh # {create_swap_file, get_swap_content}


##
# get cli list
# @Use getCliList "<globalListReferenceName>"
# @return "<Boolean>"
##
function getCliDirList() {
  local globalListRefName=$1
  local listDir=($(get_all_sub_dir_by_path "$(getCliDirectory)"))
  local -A numberMapCli
  local cliNumbers=()
  # to get cli list
  local cli
  for cli in ${listDir[@]}; do
    globalListRef=()
    split_str_with_point "${cli}" "_" globalListRef
    local orderNo="${globalListRef[1]}"
    globalListRef=("${globalListRef[@]:1}")
    globalStrRef=''
    join '_' globalListRef globalStrRef
    numberMapCli[${orderNo}]="${globalStrRef}"
    # to push new element to cliNumbers
    cliNumbers+=("${orderNo}")

    unset globalStrRef globalListRef
  done

  # sort the cli list by number.
  cliNumbers=($(echo "${cliNumbers[@]}" | tr ' ' '\n' | sort -n))
  local cliNo
  local result=()
  for cliNo in "${cliNumbers[@]}"; do
    result+=("${cliNo}_${numberMapCli[${cliNo}]}")
  done

  eval "
    ${globalListRefName}=(\${result[@]})
  "

  return "${TRUE}"
}

##
# get cli name by numberCliDir
# @Use get_cli_name_by_number_cliDir "<numberCliDir>" "<outPutStrRef>"
# @return "<boolean>"
##
function get_cli_name_by_number_cli_dir() {
  assert_not_empty "${1}"
  assert_not_empty "${2}"
  local numberCliDir=$1
  local outputStrRef=$2
  globalListRef=()
  split_str_with_point "${numberCliDir}" "_" globalListRef
  globalListRef=("${globalListRef[@]:1}")
  globalStrRef=''
  join '_' globalListRef globalStrRef
  unset globalListRef
  eval "
    ${outputStrRef}=\"${globalStrRef}\"
  "
  unset globalStrRef

  return "${TRUE}"
}

##
# get current cli path
# @use get_current_cli_path "<outPutStrRef>"
# @return <boolean>
##
function get_current_cli_path() {
  local outPutStrRef="$1"
  local preFile="${funcfiletrace[1]}"
  local cliPath=$(getCliPath)
  local cliLen=${#cliPath}
  ((cliLen++))
  local cliRelativePath=${preFile:${cliLen}}
   # get the cli name with number from the relative path.
  local pathSliceRef=$( generate_unique_var_name )
  split_str_with_point "${cliRelativePath}" '/' "${pathSliceRef}"
  local pathSlice=($( get_list_from_ref "${pathSliceRef}" ))
  local numberCliDir=${pathSlice[1]}

  assign_str_to_ref "${cliPath}/${numberCliDir}" "${outPutStrRef}"
}

##
# get current cli name
# @use get_current_cli_name "<outPutStrRef>"
# @return <boolean>
##
function get_current_cli_name() {
  assert_not_empty "$1"
  local outPutStrRef="$1"
  local preFile="${funcfiletrace[1]}"
  local cliPath=$(getCliPath)
  local cliLen=${#cliPath}
  ((cliLen++))
  local cliRelativePath=${preFile:${cliLen}}

   # get the cli name with number from the relative path.
  local pathSliceRef=$( generate_unique_var_name )
  split_str_with_point "${cliRelativePath}" '/' "${pathSliceRef}"
  local pathSlice=($( get_list_from_ref "${pathSliceRef}" ))
  local numberCliDir=${pathSlice[1]}
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numberCliDir}" "${outPutStrRef}"

  return $?
}

##
# get the cli name by name
# @use get_cli_path_by_name <cli name> <result string output ref>
# @return <boolean>
function get_cli_path_by_name() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  local inputCliName=$1
  local outPutStrRef=$2
  local allCliDirPath=$(getCliDirectory)
  for cliNamePath in "${allCliDirPath}"/*; do
    local numberCliName=${cliNamePath:${#allCliDirPath} + 1}

    local cliNameRef=$(generate_unique_var_name)
    get_cli_name_by_number_cli_dir "${numberCliName}" "${cliNameRef}"
    local cliName=$(get_str_from_ref "${cliNameRef}")

    if [[ ${cliName} == ${inputCliName}_cli ]]; then
      assign_str_to_ref "${cliNamePath}" "${outPutStrRef}"
      return ${TRUE}
    fi
    break
  done
}
##
# get the cli binary name
# @use get_cli_binary_name <cli name> <output string ref>
# @example: get_cli_binary_name qjs <cliBinaryNameRef>
#          <output the ref like: qjs_Linux_x86_64>
# @return <boolean>
##
function get_cli_binary_name() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  local cli_name=$1
  local cliBinaryNameRef="$2"
  local os_name=$(uname -s)        # Get OS name (e.g., Linux, Darwin for macOS)
  local hardware_name=$(uname -m)  # Get hardware name (e.g., x86_64)
  # Combine the cli_name with OS name and hardware name
  local binaryName="${cli_name}_${os_name}_${hardware_name}"
  assign_str_to_ref "${binaryName}" "${cliBinaryNameRef}"
  return $?
}

##
# get the executable cli in terminal
# @use get_executable_cli "<cliName.subCliName>" "<outPutStrRef>"
# @return <boolean>
function get_executable_cli() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  local subCli="$1"
  local outputResultStrRef="$2"

  local subCliInfoRef=$(generate_unique_var_name)
  split_str_with_point "${subCli}" "." "${subCliInfoRef}"
  local subCliInfoList=($(get_list_from_ref "${subCliInfoRef}"))

  local cliName=${subCliInfoList[1]}
  local subCli=${subCliInfoList[2]}
  if [[ ${#subCliInfoList[@]} -eq 1 ]]; then
    subCli=${subCliInfoList[1]}
  else
    subCli=${subCliInfoList[2]}
  fi

  local cliNamePathRef=$(generate_unique_var_name)
  get_cli_path_by_name "$cliName" "${cliNamePathRef}"
  local cliNamePath=$(get_str_from_ref "${cliNamePathRef}")
  local cpuHardwareType=$(uname -m)
  local osName=$(uname -s)

  local qjsCliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name qjs "${qjsCliPathRef}"
  local qjsCliPath=$(get_str_from_ref "${qjsCliPathRef}")
  local qjsBin="${qjsCliPath}/bin/qjs_$(uname -s)_$(uname -m)"
  local commandConfigParserJsPath="${qjsCliPath}/src/command_config_parser.mjs"

  local cliConfigJsonPath="${cliNamePath}/command_config.json"
  local swapFile=$(create_swap_file)

  # parse the
  ${qjsBin} ${commandConfigParserJsPath} \
    -c ${cliConfigJsonPath} \
    -m ${cpuHardwareType} \
    -o ${osName} \
    -cli_name "${subCli}" \
    -p "${cliNamePath}" \
    -output_file "${swapFile}"

  local result=$(get_swap_content "${swapFile}")

  assign_str_to_ref "${result}" "${outputResultStrRef}"
}

##
# @use  _load_qjs <cli name.sub cli name>
# @return <boolean>
function load_cli_from_command_config() {
    assert_not_empty "$1"
    local cliName="$1"
    local executableCliRef=$(generate_unique_var_name)
    get_executable_cli "${cliName}" "${executableCliRef}"
    local executableCli=$(get_str_from_ref "${executableCliRef}")

    if [[ $? -eq ${TRUE} ]]; then
      alias ${cliName}="${executableCli}"
      log INFO "${cliName} cli loaded"
    else
      log ERROR "Failed to load ${cliName} bin ${${executableCli}:${#APP_BASE_PATH} + 1} not found"
    fi
}

