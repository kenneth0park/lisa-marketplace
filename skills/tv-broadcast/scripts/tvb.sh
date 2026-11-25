#!/bin/sh
# tvb.sh <action> [arg] — thin entry of the tv-broadcast skill. All TV calls live in a private
# library on the TV; this script only loads it and passes the action through.
#   actions: info | video | audio_list | set_audio <id> | subtitle_list | set_subtitle <id> | caption on|off
# LISA_TV_LIB  the library file to source (default /home/root/lisa/lib/tv/broadcast.sh)
# Result: whatever the library prints. If the library is missing:
#   {"ok":false,"error":{"code":"UNAVAILABLE","message":"이 TV 에는 방송 도구가 없어요"}}  exit 1
# A market skill is installed under skills-market/, so _sdk/lib.sh may be absent — it is used only
# to print that failure, and a literal copy of the same JSON is the fallback.
lib=${LISA_TV_LIB:-/home/root/lisa/lib/tv/broadcast.sh}

if [ ! -f "$lib" ]; then
  sdklib=${LISA_SDK_LIB:-$(dirname "$0")/../../_sdk/lib.sh}
  if [ -f "$sdklib" ] && command -v jq >/dev/null 2>&1; then
    . "$sdklib"
    lisa_fail UNAVAILABLE "이 TV 에는 방송 도구가 없어요"
  fi
  printf '%s\n' '{"ok":false,"error":{"code":"UNAVAILABLE","message":"이 TV 에는 방송 도구가 없어요"}}'
  exit 1
fi

# the library finds its own helpers from this folder
TVB_LIB_DIR=$(dirname "$lib")
export TVB_LIB_DIR
. "$lib"
tvb "$@"
