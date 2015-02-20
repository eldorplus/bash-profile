echo "Removing ~/.bash-profile"
if [[ -d ~/.bash-profile ]]
then
  rm -rf ~/.bash-profile
fi

echo "Looking for original bash config..."
if [ -f ~/.bash_profile.hold ] || [ -h ~/.bash_profile.hold ]
then
  echo "Found ~/.bash_profile.hold -- Restoring to ~/.bash_profile";

  if [ -f ~/.bash_profile ] || [ -h ~/.bash_profile ]
  then
    BASHRC_SAVE=".bash_profile.omz-uninstalled-`date +%Y%m%d%H%M%S`";
    echo "Found ~/.bash_profile -- Renaming to ~/${BASHRC_SAVE}";
    mv ~/.bash_profile ~/${BASHRC_SAVE};
  fi

  mv ~/.bash_profile.hold ~/.bash_profile;

  source ~/.bash_profile;
else
  echo "Switching back to bash"
  chsh -s /bin/bash
  source /etc/profile
fi

echo "Thanks for trying out Bash Profile. It's been uninstalled."
