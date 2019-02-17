#!/bin/sh

# shellcheck disable=SC2039

# --------------
# Functions
# --------------

# Main Function
main() {
  local command_type="$1"
  shift

  case "$command_type" in
  "lint") lint_project "$@" ;;
  "install") install_deps "$@" ;;
  "--help" | "help" | *) echo "Check main() for supported commands" ;;
  esac
}

install_deps() {
  local main_option="$1"
  shift

  mint bootstrap

  if [ "$main_option" == "--global" ]; then
    while read -r mint_dep; do
      mint install "$mint_dep"
    done <Mintfile
  fi

  brew bundle
  bundle install
}

# Lint Project
lint_project() {
  set -e

  if command -v swiftlint >/dev/null; then
    swiftlint
  else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
  fi
}

# --------------
# Main Script
# --------------

main "$@"
