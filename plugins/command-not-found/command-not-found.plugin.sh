# Uses the command-not-found package bash support
# as seen in http://www.porcheron.info/command-not-found-for-bash/
# this is installed in Ubuntu

[[ -e /etc/bash_command_not_found ]] && source /etc/bash_command_not_found

# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.sh ]] && source /usr/share/doc/pkgfile/command-not-found.sh
