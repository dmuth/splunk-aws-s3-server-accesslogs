#!/bin/bash

# Errors are fatal
set -e


if test "$1" == "splunk"
then
	DEVEL="splunk"

else
	echo "! "
	echo "! Syntax: $0 ( splunk )"
	echo "! "
	echo "! splunk - Spin up Splunk container in devel mode"
	echo "! "
	exit 1

fi


#
# Change to the parent of this script
#
pushd $(dirname $0) > /dev/null
cd ..

./bin/build.sh

if test "$DEVEL" == "splunk"
then
	./go.sh --devel-splunk

fi

