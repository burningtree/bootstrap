#!/bin/sh

REPO_RAW="https://raw.githubusercontent.com/burningtree/os-bootstrap/master"
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
  if [ $? != 0 ]; then
    echo "Error installing homebrew."
    exit 1
  fi
fi

echo "Homebrew: `brew --version | egrep -o '(\d\.\d\.\d)'` [$HOMEBREW]"

echo "Installing Homebrew/bundle .."

brew tap Homebrew/bundle

BREWFILE="platform/darwin/Brewfile"
if [ ! -r $BREWFILE ]; then
  echo "Downloading Brewfile .."
  BREWFILE_LOCAL=`download $BREWFILE`
  BREWFILE=$BREWFILE_LOCAL
fi

echo "Running Brewfile: $BREWFILE"
$HOMEBREW bundle -v --file=$BREWFILE

echo "Brewfile done.\n--------"

echo "Running Masfile: $MASFILE"
cat Masfile | sed -e 's/#.*$//' | xargs mas install

