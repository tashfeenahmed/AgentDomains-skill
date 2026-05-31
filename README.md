# AgentDomains skill

A Claude / agent **skill** for [AgentDomains](https://agentdomains.co) — claim and manage
free domains (makes.fyi or agentdomains.co) for the sites an AI agent builds, straight from your agent.

> 🌐 Service: **https://agentdomains.co** · 📘 Docs: **https://docs.agentdomains.co** ·
> 🛠 CLI: **https://github.com/tashfeenahmed/AgentDomains**

## What it does

Teaches an agent to get a real public hostname (`yourname.makes.fyi`) on demand —
to expose a server, set up a webhook, host a site, or give itself a stable address —
using the `agentdomains` CLI. No web forms, no email required to start.

## Install

### Claude Code (plugin marketplace)

```text
/plugin marketplace add tashfeenahmed/AgentDomains-skill
/plugin install agentdomains@agentdomains
```

### Vercel skills.sh (Claude Code, Codex, Cursor, OpenClaw)

```bash
npx skills add tashfeenahmed/AgentDomains-skill
```

### Manual (any Agent Skills–compatible tool)

Copy the skill folder into your skills directory:

```bash
git clone https://github.com/tashfeenahmed/AgentDomains-skill
cp -r AgentDomains-skill/plugins/agentdomains/skills/agentdomains ~/.claude/skills/
```

The skill itself lives at
[`plugins/agentdomains/skills/agentdomains/SKILL.md`](plugins/agentdomains/skills/agentdomains/SKILL.md)
and follows the open [Agent Skills](https://www.anthropic.com) specification, so it
also works with Codex CLI and ChatGPT.

## Discoverability

This repo is structured as a Claude Code plugin marketplace, so it is auto-indexed
by directories like [claudemarketplaces.com](https://claudemarketplaces.com),
[SkillsMP](https://skillsmp.com), and [LobeHub](https://lobehub.com/skills).

## License

[FSL-1.1-Apache-2.0](./LICENSE).
