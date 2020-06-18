#!/bin/sh

if [ -n "${GPG_AGENT_INFO}" ]; then
    kill $(printf '%s\n' ${GPG_AGENT_INFO} | cut -d':' -f 2) >/dev/null 2>&1
fi
