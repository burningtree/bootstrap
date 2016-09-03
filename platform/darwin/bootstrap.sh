#!/bin/sh

REPO_RAW="https://raw.githubusercontent.com/burningtree/bootstrap/master"
HOMEBREW="/usr/local/bin/brew"

download()
{
  TMP_USED=1
  TARGET="/tmp/bootstrap-platform.darwin.$$.sh"
  URL="$REPO_RAW/$1"
  curl -s $URL > $TARGET
  echo $TARGET
}

echo "Checking Homebrew .."

if [ ! -f $HOMEBREW ]; then
  echo "Homebrew not installed, installing .. "
  /usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`"
fi

echo "Homebrew: `brew --version | egrep -o '(\d\.\d\.\d)'` [$HOMEBREW]"

BREWFILE="platform/darwin/Brewfile"
if [ ! -r $BREWFILE ]; then
  echo "Downloading Brewfile .."
  BREWFILE_LOCAL=`download $BREWFILE`
  BREWFILE=$BREWFILE_LOCAL
fi

echo "Running Brewfile: $BREWFILE"
#$HOMEBREW bundle check --file=$BREWFILE

