#!/bin/sh
#
# Copyright (c) 2021 Fumiyuki Shimizu
# Copyright (c) 2021 Abacus Technologies, Inc.
#
# https://opensource.org/licenses/mit-license
#
# coexistence of genuine ssh-agent, and macOS'ified ssh-agent.

umask 0077
PATH=/bin:/usr/bin:/sbin:/usr/sbin

rc=1

GENUINE_SSH_AGENT='/usr/local/bin/ssh-agent'

ssh_agent () {
  env SSH_AUTH_SOCK="$_SSH_AUTH_SOCK" SSH_AGENT_PID="$_SSH_AGENT_PID" "$GENUINE_SSH_AGENT" "$@"
}

cleanup () {
  ssh_agent -k
  exit $rc
}

SSH_AUTH_SOCK_NAME=${1:-SSH_AUTH_SOCK_METHOD2}
SSH_AGENT_PID_NAME=${2:-SSH_AGENT_PID_METHOD2}

#_SSH_AGENT_PID=$(launchctl getenv "$SSH_AGENT_PID_NAME")
#[ -n "$_SSH_AGENT_PID" ] && ps -p "$_SSH_AGENT_PID" >/dev/null && ssh_agent -k >/dev/null 2>&1

eval $(ssh_agent)
_SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
_SSH_AGENT_PID="$SSH_AGENT_PID"
launchctl setenv "$SSH_AUTH_SOCK_NAME" "$_SSH_AUTH_SOCK"
launchctl setenv "$SSH_AGENT_PID_NAME" "$_SSH_AGENT_PID"
if ! tty -s; then
  trap 'cleanup' 0
  lsof -p "$_SSH_AGENT_PID" +r >/dev/null
fi

rc=0

# end of file
