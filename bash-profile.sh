# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
  env BASH=$BASH DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT bash -f $BASH/tools/check_for_upgrade.sh
fi

# Initializes Bash Profile

# add a function path
fpath=($BASH/functions $BASH/completions $fpath)

# Set BASH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$BASH_CUSTOM" ]]; then
    BASH_CUSTOM="$BASH/custom"
fi

# Set BASH_CACHE_DIR to the path where cache files sould be created
# or else we will use the default cache/
if [[ -z "$BASH_CACHE_DIR" ]]; then
  BASH_CACHE_DIR="$BASH/cache/"
fi


# Load all of the config files in ~/bash-profile that end in .sh
# TIP: Add files you don't want in git to .gitignore
for config_file ($BASH/lib/*.sh); do
  custom_config_file="${BASH_CUSTOM}/lib/${config_file:t}"
  [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
  source $config_file
done


is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.sh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $BASH_CUSTOM $plugin; then
    fpath=($BASH_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $BASH $plugin; then
    fpath=($BASH/plugins/$plugin $fpath)
  fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # OS X's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
  SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
if [ -z "$BASH_COMPDUMP" ]; then
  BASH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${BASH_VERSION}"
fi

# Load and run compinit
autoload -U compinit
compinit -i -d "${BASH_COMPDUMP}"

# Load all of the plugins that were defined in ~/.bash_profile
for plugin ($plugins); do
  if [ -f $BASH_CUSTOM/plugins/$plugin/$plugin.plugin.sh ]; then
    source $BASH_CUSTOM/plugins/$plugin/$plugin.plugin.sh
  elif [ -f $BASH/plugins/$plugin/$plugin.plugin.sh ]; then
    source $BASH/plugins/$plugin/$plugin.plugin.sh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($BASH_CUSTOM/*.sh(N)); do
  source $config_file
done
unset config_file

# Load the theme
if [ "$BASH_THEME" = "random" ]; then
  themes=($BASH/themes/*bash-theme)
  N=${#themes[@]}
  ((N=(RANDOM%N)+1))
  RANDOM_THEME=${themes[$N]}
  source "$RANDOM_THEME"
  echo "[bash-profile] Random theme '$RANDOM_THEME' loaded..."
else
  if [ ! "$BASH_THEME" = ""  ]; then
    if [ -f "$BASH_CUSTOM/$BASH_THEME.bash-theme" ]; then
      source "$BASH_CUSTOM/$BASH_THEME.bash-theme"
    elif [ -f "$BASH_CUSTOM/themes/$BASH_THEME.bash-theme" ]; then
      source "$BASH_CUSTOM/themes/$BASH_THEME.bash-theme"
    else
      source "$BASH/themes/$BASH_THEME.bash-theme"
    fi
  fi
fi
