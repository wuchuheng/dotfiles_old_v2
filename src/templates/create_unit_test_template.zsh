#!/bin/bash
###
# 创建单元测试模板文件
#
##

declare -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import @/src/utils/log.zsh
import @/src/utils/color_printf.zsh
import @/src/utils/helper.zsh

# 输出confirm
printf "$(green_print '  Please enter a unit testing file name you want to create')\n"
printf "$(green_print '  For example: src/utils/helper.zsh')\n"
printf "$(green_print '  The unit testing file: src/utils/__test__/unit_tests/01_helper_test.zsh will be to generated')\n"
# To input the file name to create a new unit test file
read -r "UNIT_TEST_FILE?$(green_print '  💪 To input the file name to create a new unit test file:')"

if [ ! -f ${UNIT_TEST_FILE} ]; then
  log "ERROR" "Not found file: ${UNIT_TEST_FILE}";
  exit 1
fi

BASE_DIR=$(dirname "${UNIT_TEST_FILE}")
BASE_DIR=${BASE_DIR}/__test__/unit_tests
if [[ ! -d ${BASE_DIR} ]]; then
  mkdir -p ${BASE_DIR}
fi
path_info=($(split_str "${UNIT_TEST_FILE}" '/'))
readonly FILE_NAME=${path_info[${#path_info[@]}]}
relative_path=${BASE_DIR:${#DOTFILES_BASE_PATH}}
max_number="$(get_max_number_file_by_path  ${BASE_DIR})"
max_number=$((max_number + 1))
readonly FILE_NAME_INFO=($(split_str "${FILE_NAME}" '.'))
file_name_without_extend=''
for (( i = 1; i < ((${#FILE_NAME_INFO[@]})); i++ )); do
  file_name_without_extend=${file_name_without_extend}.${FILE_NAME_INFO[$i]}
done
file_name_without_extend=${file_name_without_extend:1}
last_index=$(expr ${#FILE_NAME_INFO[@]})
readonly FILE_EXTEND=${FILE_NAME_INFO[${last_index}]}
readonly UNIT_TEST_FILE=${BASE_DIR}/${max_number}_${file_name_without_extend}.test.${FILE_EXTEND}

# Create a unit testing file
cat > ${UNIT_TEST_FILE} << EOF 
#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh # {testing_callback_handle}
import @/src/utils/test_except.zsh # {except_str}

# the demo testing
function hello_world_callback_test() {
    echo "Callback function called with parameter"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "hello_world_callback_test" "Unit test ${UNIT_TEST_FILE}"

EOF

#to push the unit test file to config file config/unit_conf.sh
test_dir=$(dirname "${BASE_DIR}")
push_dir_to_test_conf ${test_dir}

log "SUCCESS" "🎉🎉🎉 Create a unit testing file ${UNIT_TEST_FILE}"
