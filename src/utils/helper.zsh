#!/usr/bin/env zsh

##
# get_all_sub_dir_by_path # print the list of elements from cli base_path.
#
# @Use get_all_sub_dir_by_path "/foo/bar"
# @Echo ("sub_path1", "sub_path2", "sub_path3")
##
function get_all_sub_dir_by_path() {
  local local_path=$1
  local sub_dir_list=($(ls -l $local_path | awk '/^d/ {print $NF}'))
  echo ${sub_dir_list[@]}
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
  echo ${array[@]}
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
  for file in ${file_list[@]}; do
    local file_number=$(echo $file | awk -F '_' '{print $1}')
    if [[ $file_number -gt $max_number ]]; then
      max_number=$file_number
    fi
  done
  echo $max_number
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
  for item in ${ALL_TEST_DIR[@]}; do
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
# to get a bin from vendor by name
##
function get_vendor_bin_by_name() {
  local name=$1
  local tool=$(printf "%s/src/vendor/${name}/bin/${name}_%s" "${APP_BASE_PATH}" "$(get_OS_symbol)")

  echo ${tool}
}

##
# get absolute base_path
#
# @Use get_full_path "src/utils"
# @Echo /Users/username/dotfiles/src/utils
##
function get_full_path(){
  first_char="${1:0:1}"
  split_symbol=""
  if [ $first_char != '/' ]; then
    split_symbol="/"
  fi
  echo "${APP_BASE_PATH}${split_symbol}$1"
}

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
    'installed_tests')
      type_str='installed_tests'
    ;;
    'uninstalled_tests')
      type_str='uninstalled_tests'
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

  echo ${file_list[@]}
}

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

function get_previous_file() {
  local previous_file=""
  local i=${#FUNCSTACK}

  while (( i > 1 )); do
    local caller_function=${FUNCSTACK[i-1]}

    if [[ $caller_function != "get_previous_file" ]]; then
      local caller_lineno=${funcfiletrace[$caller_function]}

      if [[ -n $caller_lineno ]]; then
        previous_file=${caller_lineno%%:*}
        break
      fi
    fi

    ((i--))
  done

  echo $previous_file
}
