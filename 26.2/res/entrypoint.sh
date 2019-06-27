#!/bin/sh -

set -e
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

  if [ -n "${DISPLAY}" ]; then
    echo "export DISPLAY=${DISPLAY}" >> "/home/${USERNAME}/.profile"
  fi

  if [ -f "${XAUTH_FILE}" ]; then
    ln -s "${XAUTH_FILE}" "/home/${USERNAME}"
  fi

  su -c "mkdir /home/${USERNAME}/.ssh" "${USERNAME}"
  su -c "ssh-keygen -q -t rsa -b 4096 -P ${PASSPHRASE} -f /home/${USERNAME}/.ssh/id_rsa" "${USERNAME}"
  eval su -c "'cat /home/${USERNAME}/.ssh/id_rsa.pub >> /home/${USERNAME}/.ssh/authorized_keys'" "${USERNAME}"
  chmod 400 "/home/${USERNAME}/.ssh/id_rsa"
  chmod 600 "/home/${USERNAME}/.ssh/authorized_keys"
  su -c "touch /home/${USERNAME}/.hushlogin" "${USERNAME}"
}


if [ -z "${USERNAME}" ] || [ -z "${USERID}" ] || [ -z "${GROUPID}" ]; then
  bash
else
  init_user

  sh /usr/local/bin/init_emacs.sh "${USERNAME}"

  service ssh start >/dev/null 2>&1
  sshpass -p ${PASSPHRASE} -P 'Enter passphrase for key' ssh -i "/home/${USERNAME}/.ssh/id_rsa" -o StrictHostKeyChecking=no "${USERNAME}@localhost" 2>/dev/null
fi
