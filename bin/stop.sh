#!/bin/bash
#
# Stop the Splunk Lab container
#


# Errors are fatal
set -e

echo "# "
echo "# Stopping Splunk"
echo "# "
docker kill splunk-aws-s3-logs || true


