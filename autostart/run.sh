#!/usr/bin/env bash

# Disable display power off.
xset s 0 0
xset s off

# Start Chromium
chromium-browser --kiosk
