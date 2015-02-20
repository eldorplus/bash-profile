set -e

if [ -n "$BASH" ]; then
  BASH=~/.bash-profile
fi

if [ -d "$BASH" ]; then
  echo "\033[0;33mYou already have Bash Profile installed.\033[0m You'll need to remove $BASH if you want to install"
  exit
fi

echo "\033[0;34mCloning Bash Profile...\033[0m"
#hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/eldorplus/bash-profile.git $BASH || {
#  echo "git not installed"
#  exit
#}

echo "\033[0;34mLooking for an existing bash config...\033[0m"
if [ -f ~/.bash_profile ] || [ -h ~/.bash_profile ]; then
  echo "\033[0;33mFound ~/.bash_profile.\033[0m \033[0;32mBacking up to ~/.bash_profile.hold\033[0m";
  mv ~/.bash_profile ~/.bash_profile.hold;
fi

echo "\033[0;34mUsing the Bash Profile template file and adding it to ~/.bash_profile\033[0m"
cp $BASH/templates/bash_profile.template ~/.bash_profile
sed -i -e "/^BASH=/ c\\
BASH=$BASH
" ~/.bash_profile

echo "\033[0;34mCopying your current PATH and adding it to the end of ~/.bash_profile for you.\033[0m"
sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.bash_profile

if [ "$SHELL" != "$(which bash)" ]; then
    echo "\033[0;34mTime to change your default shell to bash!\033[0m"
    chsh -s `which bash`
fi

env bash
. ~/.bash_profile
