#!/bin/bash
# Prefixes the shared status line with the active Claude profile name.
# The claude-personal alias sets CLAUDE_CONFIG_DIR, the work profile does not.

case "$CLAUDE_CONFIG_DIR" in
  *claude-personal) label='\033[1;35mPERSONAL\033[0m' ;;
  *) label='\033[1;36mWORK\033[0m' ;;
esac

printf '%b \033[2m|\033[0m ' "$label"
~/.claude/statusline.sh
