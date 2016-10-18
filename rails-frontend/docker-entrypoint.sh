#!/bin/sh
#
# This script is meant to be run as the "entrypoint" to the docker container. Its purpose is to delete any leftover
# tmp files from previous docker-compose runs. It was copied from http://stackoverflow.com/a/38732187.
#
# Prior to using this entrypoing script, running "docker-compose up" would work the first time, but on subsequent runs,
# I'd get the error "A server is already running. Check /usr/src/app/tmp/pids/server.pid." The issue is that the the 
# /tmp folder is in the mounted volume and was being persisted when in fact we wanted it deleted after every run.
# 
# This script fixes that by first deleting the offending file in /tmp before starting. 

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

exec bundle exec "$@"