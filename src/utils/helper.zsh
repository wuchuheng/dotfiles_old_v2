#!/usr/bin/env zsh

##
# get_all_sub_dir_by_path # print the list of elements from cli base_path.
#
# @Use get_all_sub_dir_by_path "/foo/bar"
# @Echo <("sub_path1", "sub_path2", "sub_path3")>
##
function get_all_sub_dir_by_path() {
  local local_path=$1
  local sub_dir_list=($(ls -l $local_path | awk '/^d/ {print $NF}'))
  echo "${sub_dir_list[@]}"
}

##
# Split a string by a symbol
#
# @desc split_str "hello world" " "
# @return ("hello" "world")
##
function split_str() {
  local str=$1
  local symbol=$2
  local array=("${=str//${symbol}/ }")
  echo "${array[@]}"
}

##
# Split string with a symbol and save the result to list pointer.
# @use split_str_with_point "<string>" "<symbol>" "<listPointer>"
# @echo <void>
# @code example
#    declare -g result=()
#    split_str_with_point "hello|world!" '|' 'result'
#    echo "${result[@]}" #hello world
# @Return <void>
##
function split_str_with_point() {
  local inputStr="$1"
  local symbol="$2"
  local listPointer="$3"
  local charBuf=''
  local firstCharInSymbol=${symbol:0:1}
  local oldI="${i}"
  for (( i = 1; i <= ${#inputStr}; i++ )); do
    local currentChar=${inputStr[${i}]}
    # if 发现一个字符与symbol的首字符匹配，则进行预测
    if [[ "${currentChar}" == "${firstCharInSymbol}" ]]; then
      local indexForNextStrInInputStr=$(expr ${i} - 1)
      local nextStrInInputStr=${inputStr:${indexForNextStrInInputStr}:${#symbol}}
      # if 当前已经预测预测到有满足条件的字符，则进行添项处理
      if [[ "${nextStrInInputStr}" == "${symbol}" ]]; then
        if [[ ${#charBuf} -gt 0 ]]; then
          eval "$listPointer+=(\"${charBuf}\")"
          charBuf=''
        fi
        # 移动游标到新的位置
        i=$(expr ${i} + ${#symbol} - 1)
      else
        charBuf="${charBuf}${currentChar}"
      fi
      # else 当前字符不满足symbol特征则缓存进charBuf
      else
        charBuf="${charBuf}${currentChar}"
    fi
    # 如已经是最后的字符了且已经有缓存字符了，那么就创建一个项
    if [[ "${i}" -eq "${#inputStr}" && "${#charBuf}" -gt 0 ]]; then
      eval "$listPointer+=(\"${charBuf}\")"
      break
    fi
  done
  i="${oldI}"
}

##
# To get the max number from a specific directory
#
# @Description the directory /foo/bar include the flowing files:
# 1_foo.txt 2_bar.txt 3_foo.txt 4_bar.txt
# max_number=$(($(get_max_number_file_by_path "/foo/bar")))
# echo $max_number # out put a max numeric value is 4 from the directory /foo/bar;
##
function get_max_number_file_by_path() {
  local local_path=$1
  local max_number=0
  local file_list=($(ls -l $local_path | awk '/^-/ {print $NF}'))
  for file in "${file_list[@]}"; do
    local file_number=$(echo $file | awk -F '_' '{print $1}')
    if [[ $file_number -gt $max_number ]]; then
      max_number=$file_number
    fi
  done
  echo "${max_number}"
}

##
# To push a new directory to src/config/test_conf.zsh
#
# @Use push_dir_to_test_conf "src/utils/__test__"
# @Echo #void
##
function push_dir_to_test_conf() {
  local test_dir=$1
  local config_file=src/config/test_conf.zsh
  import @/${config_file}
  local is_include=1
  for item in "${ALL_TEST_DIR[@]}"; do
    if [[ "${item}" == "${test_dir}" ]]; then
      is_include=0
    fi
  done
  if [[ $is_include == 1 ]]; then
  local readonly config_content=$(sed '$d' $config_file)
  cat > $config_file << EOF
${config_content}
${test_dir}
)
EOF
  fi
}

##
# get absolute base_path
#
# @Use get_full_path "src/utils"
# @Echo /Users/username/dotfiles/src/utils
##
function get_full_path() {
  first_char="${1:0:1}"
  split_symbol=""
  if [ "$first_char" != '/' ]; then
    split_symbol="/"
  fi
  echo "${APP_BASE_PATH}${split_symbol}$1"
}

##
# get_all_file_by_path # print the list of elements from cli base_path.
# get_all_file_by_path "/foo/bar"
# @echo ("file1", "file1", "file3")
##
function get_all_file_by_path() {
  local file_list=()
  local readonly base_path=$1
  for file in "$base_path"/*; do
    if [[ -f "$file" ]]; then
      last_file_name=${file//$base_path\//}
      file_list+=($last_file_name)
    fi
  done

  echo "${file_list[@]}"
}


##
# To get a runtime space while to run a test.
#
# @Use get_runtime_space_by_unit_test_name "get_a_part_of_code_test"
# @Echo /Users/wuchuheng/dotfiles/src/runtime/test/unit_test/get_a_part_of_code_test
##
function get_runtime_space_by_unit_test_name() {
  local test_name=$1
  local runtimeDir="${APP_BASE_PATH}/src/runtime"
  local test_file_name=$(get_file_name_exclude_path "${global_test_file}")
  local BASE_PATH="${runtimeDir}/test/unit_test/${test_file_name}/${test_name}"
  if [ ! -d "${BASE_PATH}" ]; then
    mkdir -p "${BASE_PATH}"
  fi

  echo "${BASE_PATH}"
}

##
# To get a file exclude the path
#
# @Use get_file_name_exclude_path "/1/2/3/file.sh"
# @Echo file.sh
##
function get_file_name_exclude_path() {
  local file=$1
  local file_info=($(split_str ${file} "/"))
  local file_info_len=${#file_info[@]}
  local test_file_name=${file_info[file_info_len]}

  echo "${test_file_name}"
}

_serializeSymbol=':xxx'
##
# @Use listEncode 'globalListPointer'
# @Echo <string>
##
function listEncode() {
  local globalListPointer="$1"
  local result=''
  eval "
    for value in \${(v)${globalListPointer}[@]}; do
      result=\"\${result}\${_serializeSymbol}\${value}\"
    done
  "
  echo "$result"
}

##
# @use listDecode "${result}" 'globalDecodeResultPointer'
# @echo <void>
##
function listDecode() {
  local encodeStr="$1"
  local resultPointer="$2"
  eval "
    declare -g -a ${resultPointer}=()
    split_str_with_point \"\${encodeStr}\" \"\${_serializeSymbol}\" \"${resultPointer}\"
  "
}

##
# check the cli existed or not
# @use cli_exits <cli_name>
# @return TRUE|FALSE
##
function cli_exits() {
  if command -v "$@" >/dev/null 2>&1; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}
