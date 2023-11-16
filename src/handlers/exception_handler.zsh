# Function to split a string by a colon and print the parts

_split_string() {

  echo "First part: $parts[1]"
  echo "Second part: $parts[2]"
}
##
# throw the error message
# @use throw "error message" [function file trace level]
function throw() {
  local errorMessage=$1
  local fncfiletraceLevel=${2:-1}

  local preFileInfo="${funcfiletrace[${fncfiletraceLevel}]}"
  local preFile=''
  local preNumLine=''
  local isPreFile=${TRUE}
  for (( i = 1; i <= ${#preFileInfo}; i++ )); do
    local currentChar=${preFileInfo[${i}]}
    if [[ ${currentChar} == ':' ]]; then
      isPreFile=${FALSE}
      continue
    fi
    if [[ ${isPreFile} == ${TRUE} ]]; then
      preFile+="${currentChar}"
    else
      preNumLine+="${currentChar}"
    fi
  done

  printf "\e[0;31mError: ${errorMessage}\e[0m\n"
  get_a_part_of_code "${preFile}" "${preNumLine}"
  for (( i = ${fncfiletraceLevel}; i <= ${#funcfiletrace[@]}; i++ )); do
    printf " ${funcfiletrace[$i]}\n"
  done
  local envType=$(get_env_type)
  if ! [[ ${envType} == 'prod' ]]; then
    exit $FALSE
  fi
}