#!/usr/bin/env zsh

##
# convert list to string with a character.
# @Use join "<symbol>" "<globalListReference>" "<globalOutputStringReference>"
# @Example:
#   globalListReference=(el1, el2, el3)
#   globalOutputStringReference=''
#   join "," globalListReference globalOutputStringReference
#   echo ${globalOutputStringReference} # 'el1,el2,el3'
# @Return "<boolean>"
##
function join() {
  local symbol=$1
  local globalListReferenceName=$2
  local globalOutputStringReferenceName=$3
  eval "
    local result=''
    result=\"\${(j:${symbol}:)${globalListReferenceName}}\"
    ${globalOutputStringReferenceName}=\${result}
  "

  return "${TRUE}"
}

