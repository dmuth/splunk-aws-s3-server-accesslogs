#!/bin/bash
#
# Build our Splunk AWS S3 Logs container
#

# Errors are fatal
set -e

#
# Change to the parent of this script
#
pushd $(dirname $0) > /dev/null
cd ..

echo "# "
echo "# Building Docker container..."
echo "# "
docker build . -f Dockerfile-splunk -t splunk-aws-s3-logs

echo "# "
echo "# Tagging container..."
echo "# "
docker tag splunk-aws-s3-logs dmuth1/splunk-aws-s3-logs

echo "# Done!"

