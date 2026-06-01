---
name: agentdomains
description: >-
  Get and manage a free public domain (yourname.makes.fyi or
  yourname.agentdomains.co) for an AI agent or app using the AgentDomains CLI. Use
  this whenever an agent builds a website or API and needs somewhere to put it, or
  needs a public hostname to expose a server, create a webhook URL, or get a stable
  address. Covers signup, claiming a name, pointing it at an IP or CNAME, getting
  HTTPS, forwarding (HTTP redirect) to an existing site, reverse-proxying the name
  to a backend over HTTPS, and delegating to your own nameservers.
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

`signup` creates an anonymous **provisional** account. There's no per-account
name limit. The **first** time you register a name you must pass `--email`: we
send a confirmation link and start a 30-day clock. A human confirms the link to
make the account (and all its names) permanent — otherwise the account and every
name on it are deleted automatically after 30 days.

```bash
agentdomains email you@example.com   # (re)send the confirmation link any time
```

## Core workflow

Always pass `--json` so you can parse results reliably.

```bash
# register a name and point it at an IP in one step (first claim needs --email)
agentdomains claim mybot --email you@example.com --type A --content 203.0.113.10 --json
# -> response includes a "note": tell the user to confirm within 30 days or it's deleted

# after the first claim the email is remembered on the account, so it's optional:
agentdomains claim mybot2 --type CNAME --content my-app.vercel.app --json

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

## Forwarding (URL redirect)

Send a name to any URL with a real HTTP redirect, served at Cloudflare's edge
with valid HTTPS. `forward` claims the label first if you don't own it, so it's
one step:

```bash
agentdomains forward mysite https://destination.example.com --json
# mysite.makes.fyi -> 302 redirect to https://destination.example.com

# 301 permanent instead of the default 302 temporary:
agentdomains forward mysite https://dest.com --permanent --json

# always land on the target root (don't carry the request path/query):
agentdomains forward mysite https://dest.com --no-preserve-path --json

# remove a forward (keeps the label):
agentdomains unforward mysite --json
```

Path and query are preserved by default. A forward and an A/AAAA/CNAME record
can't coexist on the same label (TXT still can).

## Reverse proxy (serve a backend at the name)

Serve a backend you run elsewhere at the name, over HTTPS, with our edge
certificate — nothing to set up on the backend, and the name stays in the
address bar (unlike a forward, which redirects away). `proxy` claims the label
first if you don't own it:

```bash
agentdomains proxy shop myapp.fly.dev --json
# shop.makes.fyi serves https://myapp.fly.dev over our cert, at shop.makes.fyi

# remove the proxy (keeps the label):
agentdomains unproxy shop --json
```

We terminate HTTPS at the edge and fetch the backend by its own hostname, so it
accepts the request without a certificate for the AgentDomains name. A proxy
can't coexist with a forward or an A/AAAA/CNAME on the same label.

Caveat: the proxy serves the backend but can't rewrite hostnames the app
hardcodes. Apps that bake their own domain into OAuth/SSO redirects (e.g. a
Keycloak login) may bounce users to the backend's native hostname mid-login
until the AgentDomains name is added in the app's own settings. Static sites and
apps using relative URLs work with no setup.

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
