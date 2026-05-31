# AgentDNS skill

A Claude / agent **skill** for [AgentDNS](https://makes.fyi) — claim and manage
free `*.makes.fyi` subdomains for an AI agent or app, straight from your agent.

> 🌐 Service: **https://makes.fyi** · 📘 Docs: **https://docs.makes.fyi** ·
> 🛠 CLI: **https://github.com/tashfeenahmed/AgentDNS**

## What it does

Teaches an agent to get a real public hostname (`yourname.makes.fyi`) on demand —
to expose a server, set up a webhook, host a site, or give itself a stable address —
using the `agentdns` CLI. No web forms, no email required to start.

## Install

### Claude Code (plugin marketplace)

```text
/plugin marketplace add tashfeenahmed/AgentDNS-skill
/plugin install agentdns@agentdns
```

### Vercel skills.sh (Claude Code, Codex, Cursor, OpenClaw)

```bash
npx skills add tashfeenahmed/AgentDNS-skill
```

### Manual (any Agent Skills–compatible tool)

Copy the skill folder into your skills directory:

```bash
git clone https://github.com/tashfeenahmed/AgentDNS-skill
cp -r AgentDNS-skill/plugins/agentdns/skills/agentdns ~/.claude/skills/
```

The skill itself lives at
[`plugins/agentdns/skills/agentdns/SKILL.md`](plugins/agentdns/skills/agentdns/SKILL.md)
and follows the open [Agent Skills](https://www.anthropic.com) specification, so it
also works with Codex CLI and ChatGPT.

## Discoverability

This repo is structured as a Claude Code plugin marketplace, so it is auto-indexed
by directories like [claudemarketplaces.com](https://claudemarketplaces.com),
[SkillsMP](https://skillsmp.com), and [LobeHub](https://lobehub.com/skills).

## License

[FSL-1.1-Apache-2.0](./LICENSE).
