printf '\033[0;34m%s\033[0m\n' "Upgrading Bash Profile"
cd "$BASH"
if git pull --rebase --stat origin master
then
  printf '\033[0;34m%s\033[0m\n' 'Hooray! Bash Profile has been updated and/or is at the current version.'
  printf '\033[0;34m%s\033[1m%s\033[0m\n' 'To keep up on the latest news and updates, follow us on twitter: ' 'http://twitter.com/bash-profile'
  printf '\033[0;34m%s\033[1m%s\033[0m\n' 'Get your Bash Profile swag at: ' 'http://shop.planetargon.com/'
else
  printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
fi
