#!/usr/bin/env bash

zmodload bash/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_bash_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! ~/.bash-update
}

function _upgrade_bash() {
  env BASH=$BASH /bin/sh $BASH/tools/upgrade.sh
  # update the bash file
  _update_bash_update
}

epoch_target=$UPDATE_BASH_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=13
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# bash-profile directory.
[[ -w "$BASH" ]] || return 0

if [ -f ~/.bash-update ]
then
  . ~/.bash-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_bash_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt $epoch_target ]
  then
    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
    then
      _upgrade_bash
    else
      echo "[Bash Profile] Would you like to check for updates?"
      echo "Type Y to update bash-profile: \c"
      read line
      if [ "$line" = Y ] || [ "$line" = y ]; then
        _upgrade_bash
      else
        _update_bash_update
      fi
    fi
  fi
else
  # create the bash file
  _update_bash_update
fi
