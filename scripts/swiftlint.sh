#!/bin/bash

usage() {
  echo
  echo "Usage: $0 [--path <path>] [--config <config_file>] [--check]"
  echo
  echo "Options:"
  echo "--path   : Path where find files to apply swiftlint"
  echo "--config : Config file to use (.swiftlint.yml)"
  echo "--check  : Verify if there are files without correct format"
  echo
}

validateSwiftlint() {
  swiftlint version > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "You need install swiftlint: 'brew install swiftlint'"
    exit 1
  fi
}

validateConfigFile() {
  if [ ! -f "$CONFIG_FILE" ]; then
      MY_PATH=$(cd $(dirname $0); pwd)
      CONFIG_FILE="$MY_PATH/.swiftlint.yml"
      if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found!"
        exit 1
      fi
  fi
}

validateSearchPath() {
    if [ ! -d "$SEARCH_PATH" ]; then
      echo "'$SEARCH_PATH' is not a valid path"
      exit 1
    fi
}

checkFormatFiles() {
  swiftlint lint --config "$CONFIG_FILE" --path "$SEARCH_PATH" 1> /dev/null
  if [ $? -ne 0 ]; then
    echo "There are files without correct format, please run swiftlint"
    exit 1
  fi
}

formatFiles() {
  swiftlint autocorrect --config "$CONFIG_FILE" --path "$SEARCH_PATH"
}

CHECK=false
SEARCH_PATH='../MercadoPagoSDK'
CONFIG_FILE='.swiftlint.yml'

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      --check)
      CHECK=true
      ;;

      -p|--path)
      SEARCH_PATH="$2"
      shift # past argument
      ;;

      -c|--config)
      CONFIG_FILE="$2"
      shift # past argument
      ;;

      -h|--help)
      usage
      exit
      ;;

      *) # unknown option
      echo "Unknown option: $key"
      usage
      exit
      ;;
  esac
  shift # past argument or value
done

validateSwiftlint
validateConfigFile
validateSearchPath

if $CHECK; then
  checkFormatFiles
else
  formatFiles
fi
