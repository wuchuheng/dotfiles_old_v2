#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/list_helper.zsh # {join}
import @/src/utils/test_except.zsh # {except_str}

function join_test() {
    globalList=(el1 el2 el3)
    globalOutputJoinResult=''
    join ',' globalList globalOutputJoinResult
    except_str 'el1,el2,el3' "${globalOutputJoinResult}"
    unset globalList globalOutputJoinResult
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "join_test" "Unit test src/utils/__test__/unit_tests/2_list_helper.test.zsh"

