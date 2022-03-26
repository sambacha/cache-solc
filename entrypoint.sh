#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [--list | VERSION]"
    echo ""
    echo "           VERSION     switches the default version of solc to the specified version"
    echo ""
    echo "           --list, -l  lists all installed versions of solc"
    echo ""
    exit 1
fi

INSTALL_DIR="$SSELECT_INSTALL_DIR/usr/bin"
VERSION=$1

if [ "$VERSION" = "--list" ] || [ "$VERSION" = "-l" ]; then
    find "$INSTALL_DIR" -name 'solc-v*' -printf "%f\n" | awk -F'v' '{print $2}' | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr
    exit 0
fi

SOLC_PATH=$INSTALL_DIR/solc-v$VERSION

if [ ! -f "$SOLC_PATH" ]; then
    echo "Error: ${SOLC_PATH} does not exist!"
    echo ""
    echo "Please select one of the installed versions:"
    echo ""
    echo "$($0 --list)"
    exit 1
fi

ln -fs "$SOLC_PATH" "$INSTALL_DIR"/solc-default