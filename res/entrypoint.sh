#!/bin/sh -

set -eu
umask 022

USERNAME="${EMACS_USER}"
USERID="${EMACS_UID}"
GROUPID="${EMACS_GID}"
PASSPHRASE="${USERNAME}"

XAUTH_FILE='/xfiles/.Xauthority'

init_user() {
  groupadd "${USERNAME}" -g "${GROUPID}"
  useradd "${USERNAME}" -u "${USERID}" -g "${GROUPID}" -m -d "/home/${USERNAME}" -s /bin/bash
  echo 'umask 022' >> "/home/${USERNAME}/.profile"
  echo "cd `pwd`" >> "/home/${USERNAME}/.profile"
  echo "export DISPLAY=$DISPLAY" >> "/home/${USERNAME}/.profile"

  if [ -f "${XAUTH_FILE}" ]; then
    ln -s /xfiles/.Xauthority "/home/${USERNAME}"
  fi

# chown "${USERNAME}:${USERNAME}" /work-dir

  su -c "mkdir /home/${USERNAME}/.ssh" "${USERNAME}"
  su -c "ssh-keygen -q -t rsa -b 4096 -P ${PASSPHRASE} -f /home/${USERNAME}/.ssh/id_rsa" "${USERNAME}"
  eval su -c "'cat /home/${USERNAME}/.ssh/id_rsa.pub >> /home/${USERNAME}/.ssh/authorized_keys'" "${USERNAME}"
  chmod 400 "/home/${USERNAME}/.ssh/id_rsa"
  chmod 600 "/home/${USERNAME}/.ssh/authorized_keys"
}


if [ -z "${USERNAME}" ] || [ -z "${USERID}" ] || [ -z "${GROUPID}" ]; then
  bash
else
  init_user

  sh /usr/local/bin/init_emacs.sh "${USERNAME}"

  service ssh start
  sshpass -p ${PASSPHRASE} -P 'Enter passphrase for key' ssh -i "/home/${USERNAME}/.ssh/id_rsa" -o StrictHostKeyChecking=no "${USERNAME}@localhost"
fi
