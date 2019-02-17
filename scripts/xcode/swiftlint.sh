#!/bin/sh

# --------------
# Functions
# --------------

main() {
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
