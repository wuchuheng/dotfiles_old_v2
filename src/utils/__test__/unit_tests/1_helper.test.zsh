#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler.zsh
import @/src/utils/log.zsh
import @/src/utils/test_except.zsh

# the demo testing
function hello_world_callback_test() {
    except_str "hello" "1hello"
    # log "Callback function called with parameter"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "hello_world_callback_test" "Unit test src/utils/__test__/unit_tests/1_helper.test.zsh"
