#!/bin/sh

REPO="git@github.com:burningtree/bootstrap.git"
REPO_RAW="https://raw.githubusercontent.com/burningtree/bootstrap/master"
TMP_USED=0

echo "Bootstrap initiated .."

SYSTEM_OS=`uname -s`
case $SYSTEM_OS in
  "FreeBSD") OS="freebsd"
  ;;
  "Darwin") OS="darwin"
  ;;
  "Linux") OS="linux"
  ;;
esac

if [ -z $OS ]; then
  echo "Cannot bootstrap: $SYSTEM_OS"
  exit 1
fi

function download
{
  TMP_USED=1
  URL="$REPO_RAW/$1"
  echo "Downloading: $URL"
  if [ $OS = "darwin" ]; then
    curl -s $URL > $2
  fi
}

echo "Platform: $OS"

OS_FILE="platform/$OS/bootstrap.sh"

if [ ! -r $OS_FILE ]; then
  OS_TARGET="/tmp/bootstrap-platform.$$.sh"
  download $OS_FILE $OS_TARGET

  if [ ! -s $OS_TARGET ]; then
    echo "Platform bootstrap not found: $OS_FILE"
    exit 1
  else
    OS_FILE="$OS_TARGET"
  fi
fi

# RUN PLATFORM BOOTSTRAP
/bin/sh $OS_FILE

# CLEAN
if [ ! -n $TMP_USED ]; then
  echo "Cleaning /tmp .."
  rm /tmp/bootstrap-platform.*
fi


