#!/usr/bin/env zsh

import ./helper.zsh

##
# get  test files
#
# @Use get_test_files '/src/utils' '[installed_tests | uninstalled_tests | unit_tests]'
# @Echo (
# "src/utils/__test__/[installed_tests | uninstalled_tests | unit_tests]/1_file.test.sh"
# "src/utils/__test__/[installed_tests | uninstalled_tests | unit_tests]/2_file.test.sh"
# ...
# )
#
function get_test_files() {
  local base_test_path=$1
  local path_type=$2
  local type_str=''
  local result=()
  case  ${path_type} in
    'installation_tests')
      type_str='installation_tests'
    ;;
    'uninstallation_tests')
      type_str='uninstallation_tests'
    ;;
    'unit_tests')
      type_str='unit_tests'
    ;;
    *)
      exit 1
    ;;
  esac
  base_path="${base_test_path}/${type_str}"
  if [ -d ${base_path} ]; then
   full_cli_test_path=$(get_full_path ${base_path})
   all_cli_test_files=($(get_all_file_by_path $full_cli_test_path))
   for test_file in "${all_cli_test_files[@]}"; do
     test_file=${base_path}/$test_file;
     result+=("${test_file}")
   done
  fi

  echo "${result[@]}"
}
