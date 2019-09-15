#!/bin/bash

# Errors are fatal
set -e

#
# Change to the parent of this script
#
pushd $(dirname $0) > /dev/null
cd ..


echo "# "
echo "# Pushing container to Docker Hub..."
echo "# "
docker push dmuth1/splunk-aws-s3-logs

echo "# Done!"

