#!/usr/bin/env bash
set -e

BASE_URL=$1
METRICS_URL="${BASE_URL}/metrics"
SUCCESS_REGEX="success=\"true\""
TIMEOUT=300

SLEEPTIME=0

echo "Waiting for successful apply attempts..."
until $(curl -s ${METRICS_URL} | grep -q ${SUCCESS_REGEX}); do
  sleep 1
  SLEEPTIME=$(($SLEEPTIME + 1))
  if [ $SLEEPTIME == $TIMEOUT ]; then
    echo "Timed out."
    exit 1
  fi
done

echo "Success!"

