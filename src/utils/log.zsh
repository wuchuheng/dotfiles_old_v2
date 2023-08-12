#!/usr/bin/env zsh

# Function to get the terminal width
function get_terminal_width() {
  local terminal_width=$(tput cols)
  echo "$terminal_width"
}

##
# Function to get the actual width of a string
#
# @Use get_actual_width "hello"
# @Echo 5
###
function get_actual_width() {
  local string="$1"
  local width=$(echo -E "$string" | wc -c)
  echo "$width"
}

##
# To log the message.
#
# @Use log [INFO|SUCCESS|WARNING|ERROR]
# @Echo #string
#
function log() {
  # 定义颜色常量
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'
  local YELLOW='\033[0;33m'
  local BLUE='\033[0;34m'
  local NC='\033[0m'
  # 定义图标常量
  local INFO_ICON="ℹ"
  local SUCCESS_ICON="✔"
  local WARNING_ICON="⚠"
  local ERROR_ICON="✖"
  local level="$1"
  local message="$2"
  local timestamp=$(date +"%T")
  local file_number=${funcfiletrace[1]}
  if [[ ${#file_number} -gt ${#APP_BASE_PATH} && ${file_number:0:${#APP_BASE_PATH}} == ${APP_BASE_PATH} ]]; then
    file_number=${file_number:${#APP_BASE_PATH}+1}
  fi
  local right_msg="${timestamp} ${file_number}"
  local terminal_width=$(get_terminal_width)

  local function format_print() {
      local symbol="$1:"
      local msg="$2"
      symbol="${symbol} "
      local left_msg="${symbol}${msg} "
      local addition_left_space_width=$(( $(wst "${left_msg}") - ${#left_msg} ))
      local right_space_width=$(( ${terminal_width} - ${#right_msg} - ${addition_left_space_width} ))
      if [[ $((${#left_msg} + ${#right_msg} + ${addition_left_space_width})) -le ${terminal_width} ]]; then
        local space_width=$((${terminal_width} - ${#right_msg} - ${addition_left_space_width} - ${#symbol}))
        printf  "\033[0;32m\033[1m%s\033[0m%-${space_width}s\033[2m%s\033[0m\n" "${symbol}" "${msg} " "${right_msg}"
      else
        printf  "\033[0;32m\033[1m%s\033[0m%s\033[2m%s\033[0m\n" "${symbol}" "${msg} " "${right_msg}"
      fi
  }

  case "$level" in
    "INFO")
       format_print "INFO" "${message}"
      ;;
    "SUCCESS")
       format_print "SUCCESS" "${message}"
      ;;
    "WARNING")
      printf "${YELLOW}${WARNING_ICON} %s %s %s${NC}\n" "$timestamp" "$message"
      ;;
    "ERROR")
      local left_msg="\033[0;31m\033m[1mERROR\033[0m $message"
      local right_msg="${timestamp} ${file_number}"
      echo "${left_msg} ${right_msg}"
      ;;
    *)
       format_print "INFO" "${@}"
      ;;
  esac
}

# 输出日志信息
# log "INFO" "Starting installation..."
# log "SUCCESS" "Installation completed successfully."
# log "WARNING" "Some configuration files may have been overwritten."
# log "ERROR" "Installation failed. Aborting." 

