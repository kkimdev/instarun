#!/usr/bin/env bash

INSTALL_DIR="${DG_CONFIG_HOME:-"$HOME/.config"}"
mkdir -p "$INSTALL_DIR/instarun"
cat << 'EOF' > "$INSTALL_DIR/instarun/command_not_found_hook.sh"
#!/usr/bin/env bash

# https://github.com/nix-community/nix-index/blob/master/command-not-found.sh

# for bash
command_not_found_handle () {
  echo "Executing \`$@\` with instarun. (To disable this message, run \`instarun install --run-slient\`)" >&2

  , $@
  return $?
}

# For zsh
command_not_found_handler () {
    command_not_found_handle $@
    return $?
}

instarun() {
  # TODO: Implement commands
  #       update
  #       uninstall
  #       help
  echo $@
}

EOF

# ~/.bashrc
grep -Pzo '\n# BEGIN instarun\n.*\n# END instarun' "$HOME/.bashrc" # If it fails, should skip for safety.
sed -i "/# BEGIN instarun/,/# END instarun/d" "$HOME/.bashrc"
cat << EOF >> "$HOME/.bashrc"

# BEGIN instarun
. "$INSTALL_DIR/instarun/command_not_found_hook.sh"
# END instarun
EOF

# ~/.zshrc
# TODO

# Enable for the current shell
. "$INSTALL_DIR/instarun/command_not_found_hook.sh"
