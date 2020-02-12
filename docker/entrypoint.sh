#!/bin/bash

source $HOME/.profile

echo COMMAND "$@"
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
  exec /usr/bin/dumb-init code-server --host 0.0.0.0 $@
else
  exec $@
fi
