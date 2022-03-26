#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    --force)
        export FORCE=1
        shift
        ;;
    --after)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        export SOLC_AFTER=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --before)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        export SOLC_BEFORE=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

OS=$(uname)

#
# Install locally on Linux

if [[ ${OS} = "Linux" ]]; then
    echo "Detected Linux"

    REPO_SCRIPTDIR=$(dirname "$0")
    cd "$REPO_SCRIPTDIR" || exit

    if [ ! -f ./install_linux.sh ]; then
        echo "Cannot find Linux installation script. If you are installing via Docker - it is unnecessary on Linux, instead refer to Linux installation instructions in README.md"
        exit 1
    fi

    bash install_linux.sh

    exit $?
fi


#
# Install globally or at $PREFIX on OS X

if [ -z "$PREFIX" ]; then
    EXISTING_SOLC_PATH=$(which solc)
    if [ $? -ne 0 ]; then
        # solc isn't yet installed
        EXISTING_SOLC_PATH='/usr/local/bin/solc'
    fi
else
    EXISTING_SOLC_PATH="$PREFIX/local/bin/solc"
fi

if [ -f "$EXISTING_SOLC_PATH" ]; then
    read -p "Overwrite ${EXISTING_SOLC_PATH}? [yN] " -r </dev/tty
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1 || return 1
    fi
fi

finalize () {
    chmod u+x "$EXISTING_SOLC_PATH"
    echo "Installed solc to ${EXISTING_SOLC_PATH}"
}


# The remainder of this script is auto-generated by the Dockerfile
cat >"$EXISTING_SOLC_PATH" << 'EOF'