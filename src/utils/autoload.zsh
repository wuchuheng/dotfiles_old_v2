#!/usr/bin/env zsh

if [[ -z ${_previous_source_file} ]]; then
  _previous_source_file=''
fi

if [[ -z ${_all_imported_source_files} ]]; then
  declare -g -A _all_imported_source_files=()
fi

##
# @desc 获取一个文件1-10行内容
# @use  get_a_part_of_code "/Users/wuchuheng/dotfiles/tmp.sh" 5
# @return
#
#    1  | readonly ALL_UNIT_TEST_FILES=(
#    2  | utils/__test__/unit_tests/1_helper.test.sh
#    3  | utils/__test__/unit_tests/2_helper.test.sh
#    4  | utils/__test__/unit_tests/3_helper.test.sh
# -> 5  | utils/__test__/unit_tests/4_helper.test.sh
#    6  | utils/__test__/unit_tests/5_helper.test.sh
#    7  | utils/__test__/unit_tests/6_helper.test.sh
#    8  | utils/__test__/unit_tests/7_helper.test.sh
#    9  | utils/__test__/unit_tests/8_helper.test.sh
#    10 | utils/__test__/unit_tests/9_helper.test.sh
#    11 | utils/__test__/unit_tests/10_helper.test.sh
#
##
function get_a_part_of_code() {
  local file=$1
  local lineNumber=$2;
  local allLine=$(wc -l ${file} | awk '{print $1}')
  local intervalWidth=5 # 区间宽度
  local intervalStart=$lineNumber # 区间开始坐标
  local intervalEnd=$lineNumber # 区间结始坐标
  for (( i=1; i <= 5; i++ )); do
    if ((((intervalStart - 1)) > 0)) ; then
      ((intervalStart--))
    else
      ((intervalEnd++))
    fi
    if (( ((intervalEnd + 1)) <= ${allLine} )); then
      ((intervalEnd++))
    else
      if ((((intervalStart - 1)) > 0)) ; then
        ((intervalStart--))
      fi
    fi
  done
  local result=`sed -n "${intervalStart},${intervalEnd}p" $file`
  local cln=${intervalStart}
  local lineNumberWidth=${#intervalEnd}
  while IFS= read -r line; do
    if (( cln == lineNumber )); then
      printf " \033[0;31m\033[1m->\e[0m %-${lineNumberWidth}s | $line\n" $cln
    else
      printf "    %-${lineNumberWidth}s | $line\n" $cln
    fi
    ((cln++))
  done <<< "$result"
}

function import() {
  local RED='\033[0;31m'
  local NC='\033[0m'
  local file_path=$1
  local fist_chart=${file_path:0:1}
  source_file=""
  local previous_file=${funcfiletrace[1]}
  local previous_dir="$(cd "$(dirname "${previous_file}")" && pwd)"
  case ${fist_chart} in
    # The @ symbol is equivalent to the project's root directory
    @)
        source_file=${APP_BASE_PATH}${file_path:1}
        # source_file=${file_path:2}
        ;;
    /)
	      # To load file from the absolute path in OS.
        source_file=${file_path}
      ;;
    .)
	    # To load file from a relative path in the project.
	    local second_chart=${file_path:1:1}
	    local dot_chart=${file_path:1:2}
	    # The path of the loaded file is referenced by the current file path
	    if [[ $second_chart == '/' ]]; then
              source_file=${previous_dir}${file_path:1}
            elif [[ ${dot_chart} == './' ]]; then
              source_file=${previous_dir}/${file_path}
	    fi
      ;;
    *)
          source_file=${previous_dir}/${file_path}
        ;;
  esac
  ## to check the source_file is exist or not in _all_imported_source_files
  if [[ ! -k _all_imported_source_files[$source_file] ]]; then
    if [[ ! -f ${source_file} ]]; then
      local prevFileLine="${funcfiletrace[1]}"
      local prevFile=''
      local prevLine=''
      for (( i=${#prevFileLine}; i >= 0; i-- )); do
        if [[ ${prevFileLine:$i:1} == ':' ]]; then
          prevFile=${prevFileLine:0:$i}
          break
        else
          prevLine=${prevFileLine:$i:1}${prevLine}
        fi
      done
      printf "${RED}✖ Failed to load ${source_file}, the file not found in ${prevFileLine} ${NC} \n"
      get_a_part_of_code "${prevFile}" "${prevLine}"
      exit 1
    fi

    source "$source_file";
    _all_imported_source_files[${source_file}]='loaded'
  fi
}

##
# To get the OS symbol
# @Echo darwin_arm64
##
function get_OS_symbol() {
  local OS=''
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
      OS='linux'
  elif [[ "$OSTYPE" == "darwin"* ]]; then
      OS="darwin"
  else
      printf "Unknown OS\n"
      return 1;
  fi
  local cpu_type=$(uname -p)
  if [[ ${cpu_type} == "arm" ]]; then
    OS="${OS}_arm64"
  elif [[ "${cpu_type}" == "i386" ]]; then
    OS="${OS}_x86_64"
  else
    OS="${OS}_${cpu_type}"
  fi

  echo ${OS}
}

# to load the bin tools
import @/src/config/bin_register_conf.zsh
for toolName toolPath in ${(@kv)BIN_REGISTER_CONF}; do
  function "${toolName}"() {
    local command=$(printf "%s/%s" "${APP_BASE_PATH}" "${toolPath}")
    ${command} $@
  }
done

# load env config from .env
import @/src/utils/load_env.zsh # {load_env}
local localEnvFile=${APP_BASE_PATH}/.env
if [[ -f ${localEnvFile} ]]; then
  load_env "${localEnvFile}"
fi

import @/src/config/const_conf.zsh
import @/src/handlers/exception_handler.zsh #{throw}

# clean the garbage
import @/src/utils/ref_variable_helper.zsh #{clean_ref_garbage_cache_dir}
clean_ref_garbage_cache_dir

import @/src/utils/swap_helper.zsh #{clean_swap_cache}
clean_swap_cache
