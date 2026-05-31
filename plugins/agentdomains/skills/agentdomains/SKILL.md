---
name: agentdomains
description: >-
  Get and manage a free public domain (yourname.makes.fyi or
  yourname.agentdomains.co) for an AI agent or app using the AgentDomains CLI. Use
  this whenever an agent builds a website or API and needs somewhere to put it, or
  needs a public hostname to expose a server, create a webhook URL, or get a stable
  address. Covers signup, claiming a name, pointing it at an IP or CNAME, getting
  HTTPS, and delegating to your own nameservers.
---

# AgentDomains — free domains for the sites agents build

AgentDomains hands out real, public domains from a single CLI command. Names live
under two domains: `makes.fyi` (the default) and `agentdomains.co`, so you can
claim `yourname.makes.fyi` or `yourname.agentdomains.co`. No web forms; no email
needed to start. Full docs: https://docs.agentdomains.co

## When to use this skill

Reach for AgentDomains when you need a **public hostname** and don't have one:
- exposing a local/dev server to the internet,
- a stable URL for a webhook or callback,
- hosting a small site or API for an agent,
- giving a long-running agent a memorable address.

If the user already has a domain they control, prefer that. AgentDomains is for the
"I just need a hostname, fast and free" case.

## Setup (once)

Ensure the CLI is installed, then create an account. The bundled helper does both:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```

Or manually:

```bash
go install github.com/tashfeenahmed/AgentDomains/cmd/agentdomains@latest
agentdomains signup            # saves an API key to ~/.agentdomains/config.json
```

`signup` creates a **provisional** account (quota: 1 domain, valid 30 days).
To keep it and raise the quota to 3, a human validates an email:

```bash
agentdomains email you@example.com   # a human clicks the link we send
```

## Core workflow

Always pass `--json` so you can parse results reliably.

```bash
# claim a name and point it at an IP in one step
agentdomains claim mybot --type A --content 203.0.113.10 --json

# or alias to a hostname (PaaS, tunnel, etc.)
agentdomains claim mybot --type CNAME --content my-app.vercel.app --json

# claim under agentdomains.co instead of the default makes.fyi
agentdomains claim mybot --domain agentdomains.co --type A --content 203.0.113.10 --json

# inspect / manage (add --domain to scope when a label exists under both)
agentdomains list --json
agentdomains get mybot --json
agentdomains record mybot --type A --content 203.0.113.10 --host www --json
agentdomains delete mybot --json
```

Names are claimed under `makes.fyi` by default; pass `--domain agentdomains.co` to
use the other one. Parse the `fqdn` field from `claim`/`get` to learn the live
hostname, e.g. `mybot.makes.fyi`.

## Getting HTTPS

AgentDomains handles DNS, so you bring your own certificate:
- **HTTP-01** (simplest): point the domain at your server, then
  `certbot certonly --standalone -d mybot.makes.fyi`.
- **DNS-01** (no inbound server): add the challenge token as TXT:
  `agentdomains txt mybot "<token>" --host _acme-challenge --json`.

## Nameserver delegation

To control the whole subtree yourself:

```bash
agentdomains ns mybot ns1.yourdns.com ns2.yourdns.com --json
```

## Non-interactive / sandboxed use

The CLI reads credentials from the environment, so no interactive setup is needed:

```bash
export AGENTDOMAINS_API_KEY=adom_...      # reuse an existing key
export AGENTDOMAINS_API_URL=https://api.agentdomains.co
```

You can also call the HTTP API directly; see https://docs.agentdomains.co#api.

## Notes

- Names: lowercase letters, digits, hyphens; some labels (e.g. `api`, `www`) are reserved.
- Be a good citizen: claim what you need, `delete` what you don't.
- Service & docs: https://agentdomains.co · https://docs.agentdomains.co
