#!/bin/sh

# Enable OpenVPN - Require valid .conf file in /etc/openvpn
echo "Enable OpenVPN tun interfaces"
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

# run as user asterisk by default
ASTERISK_USER=${ASTERISK_USER:-asterisk}

if [ "$1" = "" ]; then
  COMMAND="/usr/sbin/asterisk -T -W -U ${ASTERISK_USER} -p -vvvdddf"
else
  COMMAND="$@"
fi

if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
  # recreate user and group for asterisk
  # if they've sent as env variables (i.e. to macth with host user to fix permissions for mounted folders

  deluser asterisk && \
  adduser --gecos "" --no-create-home --uid ${ASTERISK_UID} --disabled-password ${ASTERISK_USER} || exit

  chown -R ${ASTERISK_UID}:${ASTERISK_UID} /etc/asterisk \
                                           /var/*/asterisk \
                                           /usr/*/asterisk
fi

exec ${COMMAND}
