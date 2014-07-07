#! /bin/bash

mkdir -p /tmp/netname/interfaces
NAME=""

if [[ -e /tmp/netname/interfaces/$@ ]] ; then
	NAME=$(cat /tmp/netname/interfaces/$@)
else
	COUNT=$(($(cat /tmp/netname/count) + 0))
	NAME="eth${COUNT}"

	echo $((${COUNT} + 1)) > /tmp/netname/count
	echo ${NAME} > /tmp/netname/interfaces/$@
fi

echo "ID_NET_NAME_SIMPLE=${NAME}"
