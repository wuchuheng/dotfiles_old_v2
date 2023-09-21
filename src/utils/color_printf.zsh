#!/usr/bin/env zsh

RED='\e[0;31m'
GREEN='\e[0;32m'
BLACK='\e[0;30m'
PINK='\e[38;2;225;113;104m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
BG_GREEN='\e[42m'
BG_RED='\e[41m'
BOLD='\e[1m'
NC='\e[0m'

function bg_green_print() {
  printf "${BOLD}${BLACK}${BG_GREEN}%s\e[0m" "$1"
}

function blob_bg_green_white_print() {
  printf "\e[1;97;102m%s\e[0m" "$1"
}

function blob_bg_red_white_print() {
  printf "\e[1;97;101m%s\e[0m" "$1"
}

function bold_print() {
  printf "\e[1m$1\e[0m"
}

function bg_red_print() {
  printf "\e[1m\e[0;30m\e[41m$1\e[0m"
}

function back_print() {
  printf "\e[0;30m$1\e[0m"
}

function pink_print() {
  printf "\e[38;2;225;113;104m$1\e[0m"
}

function green_print() {
  printf "${GREEN}${1}\e[0m"
}

function yellow_print() {
  printf "${YELLOW}$1\e[0m"
}

function blue_print() {
  printf "${BLUE}%s\e[0m" "$1"
}

function red_print() {
  printf "\e[0;31m$1\e[0m"
}

