#!/usr/bin/env bash

INSTALL_DIR="${DG_CONFIG_HOME:-"$HOME/.config"}"
mkdir -p "$INSTALL_DIR/neveri"
cat << 'EOF' > "$INSTALL_DIR/neveri/command_not_found_hook.sh"
#!/usr/bin/env bash

# https://github.com/nix-community/nix-index/blob/master/command-not-found.sh

# for bash
command_not_found_handle () {
  echo "Executing \`$@\` with neveri. (To disable this message, run \`neveri install --run-slient\`)" >&2

  , $@
  return $?
}

# For zsh
command_not_found_handler () {
    command_not_found_handle $@
    return $?
}

neveri() {
  # TODO: Implement commands
  #       update
  #       uninstall
  #       help
  echo $@
}

EOF

# ~/.bashrc
grep -Pzo '\n# BEGIN neveri\n.*\n# END neveri' "$HOME/.bashrc" # If it fails, should skip for safety.
sed -i "/# BEGIN neveri/,/# END neveri/d" "$HOME/.bashrc"
cat << EOF >> "$HOME/.bashrc"

# BEGIN neveri
. "$INSTALL_DIR/neveri/command_not_found_hook.sh"
# END neveri
EOF

# ~/.zshrc
# TODO

# Enable for the current shell
. "$INSTALL_DIR/neveri/command_not_found_hook.sh"
