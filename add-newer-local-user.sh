#!/bin/bash

#Make sure the script is executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
	echo 'Command not executed with superuser privileges' >&2
	echo "Usage: sudo ${0}" >&2
	exit 1
fi

#Make sure they provide the username, else provide a usage statement.
if [[ "${#}" -eq 0 ]]
then
	echo 'username not provided' >&2
	echo "Usage: sudo ${0} USER_NAME [COMMENT]..." >&2
	exit 1
fi

#Use first argument as username and any remaining arguments as comment.
USER_NAME="${1}"
shift
if [[ "${#}" -ne 0 ]]
then
	COMMENT="${*}"
else
	COMMENT='No comment provided'
fi


#Generate password for the account.
PASSWORD="$(date +%s%N | sha256sum | head -c 48)"

#Create account.(If not created, inform user and exit with status 1.)
useradd -c "${COMMENT}" -m  "${USER_NAME}" &> /dev/null
if [[ "${?}" -ne 0 ]]
then
	echo 'Account could not be created.' >&2
	exit 1
fi

echo "${PASSWORD}" | passwd --stdin "${USER_NAME}" &> /dev/null

if [[ "${?}" -ne 0 ]]
then
	echo 'Account could not be created.' >&2
	exit 1
fi

passwd -e "${USER_NAME}" &> /dev/null

#Display username, password, and host
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
echo

exit 0