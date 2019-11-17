#!/bin/bash

#
# A simple file-send client"
#

usage="\
Usage: fsend [--help] [--host domain_or_ip] [--port port] 
         filename1 [filename2, ...]
         directory1 [directory2, ...]

A simple file-send client"

clear_tmp() {
  rm -f "${TMP_DIR}/archive.gpg"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -? | --help)
      echo "$usage"
      exit 0
      ;;
    -h | --host)
      HOST=$2
      shift
      shift
      ;;
    -p | --port)
      PORT=$2
      shift
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "$usage" 1>&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

TMP_DIR="/tmp/file-transfer"

mkdir -p "$TMP_DIR"
clear_tmp
export GPG_TTY=$(tty)
tar -cf - "$@" | gpg --set-filename x.tar --symmetric --cipher-algo=AES256 \
                  --output "${TMP_DIR}/archive.gpg" > /dev/null
trap clear_tmp INT

HOST=${HOST:-0.0.0.0}
PORT=${PORT:-8000}
if [[ "$(python -V 2>&1)" =~ "Python 2" ]]; then
  (cd "$TMP_DIR" && python -m SimpleHTTPServer $PORT)
else
  (cd "$TMP_DIR" && python -m http.server $PORT --bind $HOST)
fi
