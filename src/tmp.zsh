#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/testing_callback_handler/global_current_test.zsh


${globalCurrentTest[setPassedStatus]} ${FALSE}
${globalCurrentTest[getPassedStatus]}

${globalCurrentTest[setName]} 'testName'
${globalCurrentTest[getName]}
globalDescPointer="test desc test desc"
${globalCurrentTest[setDesc]} 'globalDescPointer'
${globalCurrentTest[getDesc]}

