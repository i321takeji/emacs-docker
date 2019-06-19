#!/bin/sh -

set -e

USERNAME="$1"

ORIG_DOT_DIR="/dot.emacs.d"

if [ -d "${ORIG_DOT_DIR}" ]; then
  cp -r "${ORIG_DOT_DIR}" "/home/${USERNAME}/.emacs.d"
  chown "${USERNAME}:${USERNAME}" -R "/home/${USERNAME}/.emacs.d"
fi
