#!/bin/bash

#
# A simple file-receive client"
#

usage="\
Usage: frecv --host domain_or_ip [--help] [--port port] 

A simple file-receive client"

if [[ $# -eq 0 ]]; then
  echo "$usage" 1>&2
  exit 1
fi

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

export GPG_TTY=$(tty)
HOST=${HOST:-127.0.0.1}
PORT=${PORT:-8000}
curl -s $HOST:$PORT/archive.gpg | gpg --decrypt 2>/dev/null | tar  -xvf -
