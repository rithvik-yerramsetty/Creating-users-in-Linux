# Creating-users-in-Linux
This repository contains two scripts-
1.add-newer-local-users.sh
2.disable-local-users.sh

The script add-newer-local-users.sh is used to create local users on a Linux machine. It has the following features-

The script:

1)Enforces that it be executed with superuser (root) privileges. If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1. All messages associated with this event will be displayed on standard error.

2)Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1. All messages associated with this event will be displayed on standard error.

3)Uses the first argument provided on the command line as the username for the account. Any remaining arguments on the command line will be treated as the comment for the account. Automatically generates a password for the new account.

4)Informs the user if the account was not able to be created for some reason. If the account is not created, the script is to return an exit status of 1. All messages associated with this event will be displayed on standard error.

5)Displays the username, password, and host where the account was created. This way the help desk staff can copy the output of the script in order to easily deliver the information to the new account holder.

6)Suppress the output from all other commands.

The script disable-local-users.sh is used to disable/delete/archive local users on a Linux machine. It has the following features-
 
1)Enforces that it be executed with superuser (root) privileges. If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1. All messages associated with this event will be displayed on standard error.

2)Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1. All messages associated with this event will be displayed on standard error.

3)Disables (expires/locks) accounts by default.

4)Allows the user to specify the following options:
    i)-d Deletes accounts instead of disabling them.
    ii) -r Removes the home directory associated with the account(s).
    iii)-a Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives       directory.
    iv)Any other option will cause the script to display a usage statement and exit with an exit status of 1.

5)Accepts a list of usernames as arguments. At least one username is required or the script will display a usage statement much like you would find in a man page and return an exit status of 1. All messages associated with this event will be displayed on standard error.

6)Refuses to disable or delete any accounts that have a UID less than 1,000.

7)Informs the user if the account was not able to be disabled, deleted, or archived for some reason.

8)Displays the username and any actions performed against the account.

