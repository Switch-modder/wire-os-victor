#!/usr/bin/env bash
# usage: ./cloud/protoc-wrapper.sh <path/to/protoc> <args>
SCRIPT_PATH="$(dirname $([ -L $0 ] && echo "$(dirname $0)/$(readlink -n $0)" || echo $0))"
TOPLEVEL="$(cd "${SCRIPT_PATH}/.." && pwd)"

if [ -n "$1" ] && [ -f "$1" ]; then
    PROTOC="$1"
    shift
else
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    if [ "$ARCH" = "x86_64" ]; then
        ARCH_DIR=""
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        ARCH_DIR="-arm64"
    fi
    
    if [ "$OS" = "darwin" ]; then
        PROTOC="${TOPLEVEL}/3rd/protobuf/mac${ARCH_DIR}/bin/protoc"
    elif [ "$OS" = "linux" ]; then
        PROTOC="${TOPLEVEL}/3rd/protobuf/linux${ARCH_DIR}/bin/protoc"
    fi
fi

if [ ! -f "$PROTOC" ]; then
    echo "Error: protoc not found at $PROTOC"
    exit 1
fi

PATH="$PATH:${TOPLEVEL}/cloud/go/bin" "$PROTOC" "$@"