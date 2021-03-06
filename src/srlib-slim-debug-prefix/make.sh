#!/bin/bash

if [ -n "$1" ]; then
  cat /dev/null > slim-debug-prefix.ref
  for s in $1; do
    echo '*$FROM '$s >> slim-debug-prefix.ref
  done
fi

SCRIPT_FLAGS=--scratch ../make.sh \
  srlib-slim-debug-prefix slim-debug-prefix slim-debug-prefix
rm -f ../../build/srlib-slim-debug-prefix/{LibraryEx,GetOpt}.*
