#!/usr/bin/env bash
# shellcheck disable=1090

activateVenv() {
  if [[ -d "$PWD/venv" ]]; then
    source "$PWD/venv/bin/activate"
  fi
}

gotoPyProj() {
  echo "Which Project: "
  touch ~/PycharmProjects/quit.txt
  local cdDir
  select DIRECTORY in ~/PycharmProjects/*; do
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
  rm ~/PycharmProjects/quit.txt
  if [[ "$cdDir" != "exit" ]]; then
    if [[ -d "$cdDir" ]]; then
      cd "$cdDir" || echo "Could not cd into $cdDir"
      activateVenv
    else
      echo "Could not cd into $cdDir"
    fi
  fi
}

pipListOutdated() {
  pip list --outdated
}

pipInstallUpgrade() {
  pip install --upgrade "$@"
}

pipInstall() {
  pip install "$@"
}

pipInstallReqs() {
  pip install -r requirements.txt
}

pipUpgradeReqs() {
  pip install --upgrade -r requirements.txt
}

pipInstallDevReqs() {
  pip install -r dev-requirements.txt
}

pipUpgradeDevReqs() {
  pip install --upgrade -r dev-requirements.txt
}

pyFormat() {
  black --py36 "$@"
}
