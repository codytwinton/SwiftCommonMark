#!/bin/sh

# --------------
# Main Script
# --------------

xcodebuild build test -project SwiftCommonMark.xcodeproj -scheme SwiftCommonMark CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""
