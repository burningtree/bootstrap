#!/bin/sh

PACKAGES="fish vim-lite git tmux wget curl apg aria2 mtr-nox11 ncdu jq the_silver_searcher tree"

# check sudo
SUDO="/usr/local/bin/sudo"

if [ ! -x $SUDO ]; then
  echo "Installing sudo .."
  while ! su -m root -c "pkg install sudo"; do :; done
fi
echo "Sudo: $SUDO"

echo "Checking sudoers group .."
WHEEL_STATUS=`cat /usr/local/etc/sudoers | egrep -o '^\%wheel ALL=\(ALL\) ALL'`
if [ ! "$WHEEL_STATUS" ]; then
  while ! su -m root -c "echo \"%wheel ALL=(ALL) ALL\" >> /usr/local/etc/sudoers"; do :; done
fi

echo "Installing core packages .."
$SUDO pkg install $PACKAGES
