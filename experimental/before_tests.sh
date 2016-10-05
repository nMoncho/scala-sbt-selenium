#!/bin/bash

rm -f /tmp/.X*lock

Xvfb :99 -ac -screen 0 1366x768x24 &

DISPLAY=:99
export DISPLAY

