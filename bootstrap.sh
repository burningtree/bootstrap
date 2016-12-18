#!/bin/sh

REPO="git@github.com:burningtree/os-bootstrap.git"
REPO_RAW="https://raw.githubusercontent.com/burningtree/os-bootstrap/master"
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

download()
{
  TMP_USED=1
  URL="$REPO_RAW/$1"
  echo "Downloading: $URL"
  if [ $OS = "freebsd" ]; then
    fetch -qo $2 $URL
  else
    curl -s $URL > $2
  fi
}

echo "-------------------------------"
echo "Platform: $OS"
echo "Architecture: `uname -m`"
echo "Hostname: `hostname`"
echo "-------------------------------"

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

echo "Running platform bootstrap: $OS_FILE"

/bin/sh $OS_FILE

# CLEAN
echo "Cleaning .."
rm /tmp/bootstrap-platform.* 2>/dev/null

echo "Done. Bootstrap complete."

