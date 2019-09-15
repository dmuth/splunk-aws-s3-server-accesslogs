#!/bin/bash
#
# This script spins up Splunk to ingest AWS S3 Access logs.
#

# Errors are fatal
set -e

#
# Things the user can override
#
SPLUNK_PORT=${SPLUNK_PORT:-8000}
SPLUNK_PASSWORD=${SPLUNK_PASSWORD:-password1}
SPLUNK_DATA=${SPLUNK_DATA:-splunk-data}

DOCKER_IT=""
DOCKER_V=""

DEVEL_SPLUNK=""

if test ! "$SPLUNK_START_ARGS" -o "$SPLUNK_START_ARGS" != "--accept-license"
then
	echo "! "
	echo "! You need to access the Splunk License in order to continue."
	echo "! "
	echo "! Please restart this container with SPLUNK_START_ARGS set to \"--accept-license\""
	echo "! as follows:"
	echo "! "
	echo "! SPLUNK_START_ARGS=--accept-license"
	echo "! "
	exit 1
fi

PASSWORD_LEN=${#SPLUNK_PASSWORD}
if test $PASSWORD_LEN -lt 8
then
	echo "! "
	echo "! "
	echo "! Admin password needs to be at least 8 characters!"
	echo "! "
	echo "! Password specified: ${SPLUNK_PASSWORD}"
	echo "! "
	echo "! "
	exit 1
fi


ARG1=""

if test "$1" == "--devel-splunk"
then
	DEVEL_SPLUNK=1

fi


#
# Create our Docker command line
#
DOCKER_NAME="--name splunk-aws-s3-logs"
DOCKER_RM="--rm"
DOCKER_V="-v $(pwd)/user-prefs.conf:/opt/splunk/etc/users/admin/user-prefs/local/user-prefs.conf"
DOCKER_PORT="-p ${SPLUNK_PORT}:8000"
DOCKER_LOGS="-v $(pwd)/logs:/logs"
DOCKER_DATA="-v $(pwd)/${SPLUNK_DATA}:/data"

#
# Create our user-prefs.conf which will be pulled into Splunk at runtime
# to set the default app.
#
cat > user-prefs.conf << EOF
#
# Created by Splunk AWS S3 Logs
#
[general]
default_namespace = splunk-aws-s3-logs
EOF


echo "   ____            _                   _                                          "
echo "  / ___|   _ __   | |  _   _   _ __   | | __                                      "
echo "  \___ \  | '_ \  | | | | | | | '_ \  | |/ /                                      "
echo "   ___) | | |_) | | | | |_| | | | | | |   <                                       "
echo "  |____/  | .__/  |_|  \__,_| |_| |_| |_|\_\                                      "
echo "          |_|                                                                     "
echo
echo "      _     __        __  ____      ____    _____     _                           "
echo "     / \    \ \      / / / ___|    / ___|  |___ /    | |       ___     __ _   ___ "
echo "    / _ \    \ \ /\ / /  \___ \    \___ \    |_ \    | |      / _ \   / _\` | / __|"
echo '   / ___ \    \ V  V /    ___) |    ___) |  ___) |   | |___  | (_) | | (_| | \__ \'
echo "  /_/   \_\    \_/\_/    |____/    |____/  |____/    |_____|  \___/   \__, | |___/"
echo "                                                                      |___/       "


echo "# "
echo "# About to run Splunk AWS S3 Logs!"
echo "# "
echo "# Before we do, please confirm these settings:"
echo "# "
echo "# URL:                               https://localhost:${SPLUNK_PORT}/ (Set with \$SPLUNK_PORT)"
echo "# Login/Password:                    admin/${SPLUNK_PASSWORD} (Set with \$SPLUNK_PASSWORD)"
echo "# Splunk Data Directory:             ${SPLUNK_DATA} (Set with \$SPLUNK_DATA)"
echo "# "

if test "$SPLUNK_PASSWORD" == "password1"
then
	echo "# "
	echo "# PLEASE NOTE THAT YOU USED THE DEFAULT PASSWORD"
	echo "# "
	echo "# If you are testing this on localhost, you are probably fine."
	echo "# If you are not, then PLEASE use a different password for safety."
	echo "# If you have trouble coming up with a password, I have a utility "
	echo "# at https://diceware.dmuth.org/ which will help you pick a password "
	echo "# that can be remembered."
	echo "# "
fi


echo "> "
echo "> Press ENTER to run Splunk AWS S3 Logs with the above settings, or ctrl-C to abort..."
echo "> "
read


CMD="${DOCKER_RM} ${DOCKER_NAME} ${DOCKER_PORT} ${DOCKER_LOGS} ${DOCKER_DATA} ${DOCKER_V}"
CMD="${CMD} -e SPLUNK_START_ARGS=${SPLUNK_START_ARGS}"
CMD="${CMD} -e SPLUNK_PASSWORD=${SPLUNK_PASSWORD}"

if test ! "$DEVEL_SPLUNK"
then
	ID=$(docker run $CMD -d dmuth1/splunk-aws-s3-logs)

else
	DOCKER_V_APP="-v $(pwd)/app:/opt/splunk/etc/apps/splunk-aws-s3-logs/local"
	docker run $CMD ${DOCKER_V_MNT} ${DOCKER_V_APP} -it dmuth1/splunk-aws-s3-logs bash

fi

echo "# "
echo "# Splunk AWS S3 Logs launched with Docker ID: "
echo "# "
echo "# ${ID} "
echo "# "
echo "# To check the logs for Splunk AWS S3 Logs: docker logs splunk-aws-s3-logs"
echo "# "
echo "# To kill Splunk AWS S3 Logs: docker kill splunk-aws-s3-logs"
echo "# "


