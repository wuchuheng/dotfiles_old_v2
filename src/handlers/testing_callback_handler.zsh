#!/usr/bin/env zsh

# Declare the function with two pro: the callback contained a testing logic, the testing name and the testing description.
function testing_callback_handle() {
    local callback="$1" # the callback function contained a testing logic
    global_test_name="$1"
    global_test_desc="$2"
    global_start_timestamp=$(date +%s)
    global_duration=0; # Units/second
    global_is_pass=0
    # local result=$(${callback})
    $callback
    local result=()
    if (( global_is_pass != 0 )); then
      global_test_file_is_pass=1
      ((global_total_fail++))
    else
      ((global_total_pass++))
      global_pass_test_desc_items+=("${global_test_desc}")
      global_pass_test_name_items+=("${global_test_name}")
      global_pass_test_results+=("${result}")
      local test_name_len=${#global_test_name}
      if (( test_name_len > global_max_pass_tests_len )); then
        global_max_pass_tests_len=$test_name_len
      fi
    fi
    ((global_total_tests++))
    global_duration=$(expr $(date +%s) - ${global_start_timestamp})
}
