#!/usr/bin/env bash
# Ensure the agentdns CLI is installed and an account exists.
set -e

if ! command -v agentdns >/dev/null 2>&1; then
  echo "Installing agentdns CLI..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/tashfeenahmed/AgentDNS/cmd/agentdns@latest
    # make sure GOBIN is on PATH for this session
    export PATH="$PATH:$(go env GOPATH)/bin"
  else
    echo "Go toolchain not found. Install Go, or download a prebuilt binary from:"
    echo "  https://github.com/tashfeenahmed/AgentDNS/releases"
    exit 1
  fi
fi

if [ ! -f "$HOME/.agentdns/config.json" ] && [ -z "${AGENTDNS_API_KEY:-}" ]; then
  echo "Creating an AgentDNS account..."
  agentdns signup
else
  echo "AgentDNS already configured."
  agentdns whoami || true
fi

echo
echo "Ready. Claim a subdomain with:  agentdns claim <name> --type A --content <ip> --json"
echo "Docs: https://docs.makes.fyi"
