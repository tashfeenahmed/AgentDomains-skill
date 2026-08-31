# Publishing to ClawHub

The Claude Code plugin marketplace and skills.sh both read this repo directly, so a `git push`
is the whole release for them. [ClawHub](https://clawhub.ai/tashfeenahmed/skills/agentdomains)
does not: it holds its own copy of the skill, uploaded version by version. If nobody pushes, the
listing keeps serving whatever was uploaded last — which is how it sat on v0.3.0 while this repo
was on v0.5.0.

So: **after bumping the version here, do the four commands below.** It takes about a minute.

## Publish a new version

```bash
cd AgentDomains-skill

npx clawhub@latest login

npx clawhub@latest publish plugins/agentdomains/skills/agentdomains \
  --name "AgentDomains" \
  --slug agentdomains \
  --version 0.5.0 \
  --changelog "Reverse proxy, single-record removal, account closure, MCP server." \
  --source-repo tashfeenahmed/AgentDomains-skill \
  --source-commit "$(git rev-parse HEAD)" \
  --source-ref main \
  --source-path plugins/agentdomains/skills/agentdomains

npx clawhub@latest inspect tashfeenahmed/agentdomains
```

`login` opens a browser device flow — approve with the GitHub-linked account that owns the
listing, and the token is written to `~/Library/Application Support/clawhub/config.json` (on
Linux, `~/.config/clawhub/config.json`). It persists, so every release after the first one skips
this step. `inspect` should print the version you just pushed.

Set `--version` to the number in
[`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json) and
[`plugins/agentdomains/.claude-plugin/plugin.json`](../plugins/agentdomains/.claude-plugin/plugin.json).
Those two and ClawHub should never disagree.

## Check it before you push it

`--dry-run --json` runs the whole thing without uploading, and needs no login:

```bash
npx clawhub@latest publish plugins/agentdomains/skills/agentdomains \
  --name "AgentDomains" --version 0.5.0 --dry-run --json
```

It prints the slug, the display name, the version it would publish and the version already up
there, so it is the fastest way to see whether the listing has gone stale.

## Two things that bite

**Pass `--name "AgentDomains"`.** Without it the CLI derives the display name from the folder and
publishes it as `Agentdomains`, lowercase d. `--slug agentdomains` is likewise worth passing
explicitly so a rename can never happen by accident.

**The listing says MIT-0 and cannot be made to say anything else.** This is not a stale field and
there is no web-UI setting for it: ClawHub hardcodes one licence for every skill on the platform
(`PLATFORM_SKILL_LICENSE = "MIT-0"` in the CLI's own schema, which types the field as literally
`"MIT-0" | null`). This repo is [FSL-1.1-Apache-2.0](../LICENSE), so the two disagree, and only
the owner can decide what to do about it — accept MIT-0 on the two files ClawHub actually
distributes (`SKILL.md` and `scripts/setup.sh`), or take the listing down. Don't spend time
hunting for the setting; it doesn't exist.

## What actually gets uploaded

Only the skill folder — `SKILL.md` and `scripts/setup.sh`, two files. The README, the LICENSE and
the plugin manifests stay behind in the repo. That is why the licence shown on the listing is
ClawHub's and not ours.
