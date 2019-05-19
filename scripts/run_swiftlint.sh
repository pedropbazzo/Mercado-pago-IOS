#!/bin/sh

git log -n1 --oneline --no-merges | grep -e '\[ci deploy\]' -e '\[deploy ci\]' > /dev/null
if [[ $? -eq 0 ]]; then
  echo "Skip tests for deploy"
  exit 0
fi

swiftlint version
./scripts/swiftlint.sh --check --config .swiftlint.yml --path 'MercadoPagoSDK'
