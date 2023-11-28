#!/usr/bin/env bash

_usage() {
  local message=$1
  echo "Usage:
. include.sh
FACT1=value1 [FACT2=value2 ...] . data.sh
Note that the script must be sourced not executed."
  [ ! -z "$message" ] && echo "$message"
  return 0
}

[[ "$0" == "${BASH_SOURCE[0]}" ]] && [ "$1" == "-h" ] && _usage && exit 1
[[ "$0" == "${BASH_SOURCE[0]}" ]] && _usage "This script must be sourced" && exit 1

[ "$1" == "-h" ] && _usage && return 0

[ -z "$INCLUDED" ] && _usage "You forgot to run . include.sh" && return 1

# Local hierarchy.
_ data/common.sh
_ data/tdm/"$TDM".sh
#_ data/stage/"$STAGE"/tdm/"$TDM".sh
_ data/envgroup/"$ENVGROUP".sh
_ data/envgroup/"$ENVGROUP"/environment/"$ENVIRONMENT".sh
_ data/stage/"$STAGE"/stack/"$STACK".sh

# Framework hierarchy.
[ ! -z "$TDM" ] && \
_ include/data/tdm/common.sh
_ include/data/stage/"$STAGE"/tdm/"$TDM".sh
_ include/data/stage/"$STAGE"/stack/"$STACK".sh
