#!/bin/bash

#This script is for disabling/deleting user account.

usage() {
	# Display the usage and exit.
	local MESSAGE="${@}"
	echo "${MESSAGE}"
	echo "Usage: " >&2
	echo "sudo ${0} [-d] [-r] [-a] USER_NAME [USER_NAME]..." >&2
	echo "-d     Deletes account instead of disabling them." >&2
	echo "-r     Removes the home directory associated with the account(s)." >&2
	echo "-a     Creates an archive of the home directory associated with the account(s) and stores the archive in the /archives directory." >&2
	exit 1
}

# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -ne 0 ]]
then
	echo 'Use sudo or run as root.' >&2
	exit 1
fi

# Parse the options.
while getopts dra OPTION
do
	case ${OPTION} in
		d)
			DELETE_USER='true'
			;;
		r)
			REMOVE_OPTION='-r'
			;;
		a)
			ARCHIVE='true'
			;;
		?)
			usage 'Invalid Option'
			;;
	esac
done

# Remove the options while leaving the remaining arguments.
OPTIND="$(( OPTIND - 1 ))"
shift "${OPTIND}"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
	usage 'Account name not specified'
fi

DIR="/archives"

# Loop through all the usernames supplied as arguments.
for USER_NAME in ${@}
do
	# Make sure the ARCHIVE_DIR directory exists.
	PUID=$(id -u "${USER_NAME}")
	if [[ "${PUID}" -lt 1000 ]]
	then
		echo "The account ${USER_NAME} is a system account" >&2
		exit 1
	fi

    # Archive the user's home directory and move it into the DIR
	if [[ "${ARCHIVE}" = 'true' ]]
	then
		if [[ ! -d  "${DIR}" ]]
		then
			mkdir -p "${DIR}"
		fi
		tar -cf "${DIR}/${USER_NAME}.tar" "/home/${USER_NAME}"
		if [[ "${?}" -ne 0 ]]
		then
			echo "Account ${USER_NAME} is not archived"
		else
			echo "Username: ${USER_NAME}       Action: Archived"
		fi
	fi # END of if "${ARCHIVE}" = 'true'

	if [[ "${DELETE_USER}" = 'true' ]]
	then
		# Delete the user
		userdel ${REMOVE_OPTION} ${USER_NAME}
		if [[ "${?}" -ne 0  ]]
		then
			echo "Account ${USER_NAME} is not deleted"
		else
			echo "Username: ${USER_NAME}       Action: Deleted"
		fi
	else
		sudo chage -E 0 ${USER_NAME}
		if [[ "${?}" -ne 0  ]]
		then
			echo "Account ${USER_NAME} is not disabled"
		else
			echo "Username: ${USER_NAME}       Action: Disabled"
		fi
	fi
done

exit 0