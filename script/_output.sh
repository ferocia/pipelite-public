#!/usr/bin/env bash

red=`tput setaf 1`
yellow=`tput setaf 3`
green=`tput setaf 2`
gray=`tput setaf 7`
reset=`tput sgr0`

print_error() {
  echo "${red}  [ ERROR ] $@${reset}"
}

print_ok() {
  echo "${green}  [ OK ] $@${reset}"
}

print_notice() {
  while read data; do
    echo "${gray}${data}${reset}"
  done;
}

print() {
  printf "$@\n"
}

print_error_and_fail() {
  print_error "$@"
  exit 1
}

indent() {
  sed 's/^/  /';
}
