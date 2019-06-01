#!/usr/bin/env bash

gotoJSProj() {
  echo "Which Project: "
  touch ~/WebstormProjects/quit.txt
  local cdDir
  select DIRECTORY in ~/WebstormProjects/*; do
    case $DIRECTORY in
    *)
      if [[ "$DIRECTORY" == *quit.txt** ]]; then
        echo "Exiting"
        cdDir="exit"
      else
        cdDir="$DIRECTORY"
        echo "You picked $DIRECTORY ($REPLY)"
      fi
      break
      ;;
    esac
  done
  rm ~/WebstormProjects/quit.txt
  if [[ "$cdDir" != "exit" ]]; then
    if [[ -d "$cdDir" ]]; then
      cd "$cdDir" || echo "Could not cd into $cdDir"
    else
      echo "Could not cd into $cdDir"
    fi
  fi
}

jsDepsUpdate() {
  ncu -u && yarn install
}

jsDepInstall() {
  yarn add "$@"
}

dryRunPublishJS() {
  npm publish --dry-run
}

publishProjectJS() {
  npm publish
}

avaFailFast() {
  node ./node_modules/.bin/ava -v --fail-fast "$@"
}

avaSerialFailFast() {
  node ./node_modules/.bin/ava -v --fail-fast --serial "$@"
}

jsFormatPrettierStandard() {
  node ./node_modules/.bin/prettier-standard "$@"
}

jsFormatPrettier() {
  node ./node_modules/.bin/prettier --write "$@"
}
