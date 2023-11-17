#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh # {testing_callback_handle}
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/debug_helper.zsh # {assert_not_empty}


# the demo testing
function assert_not_empty_test() {
    assert_not_empty "hello"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "assert_not_empty_test" "Unit test src/utils/__test__/unit_tests/6_debug_helper.test.zsh"
