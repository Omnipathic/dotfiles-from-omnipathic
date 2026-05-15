#!/usr/bin/env sh

if pidof swww-daemon > /dev/null; then
    swww kill
else
    swww-daemon &
fi
