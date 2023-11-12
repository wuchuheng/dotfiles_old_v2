#!/usr/bin/env bash

get_os_symbol() {
  case "$(uname -s)" in
    Linux*)
      if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [ "$ID" = "ubuntu" ]; then
          echo "UbuntuOS"
        elif [ "$ID" = "centos" ]; then
          echo "CentOS"
        else
          echo "$ID" # or you could default to just "Linux"
        fi
      else
        echo "Linux"
      fi
      ;;
    Darwin*)
      echo "MacOS"
      ;;
    *)
      echo "unknown:$(uname -s)"
      ;;
  esac
}

# Usage
os_symbol=$(get_os_symbol)
echo "$os_symbol"
