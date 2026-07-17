# Security

This repository is intentionally safe for a public portfolio.

- Never commit credentials, tokens, cookies, private keys, account IDs, customer domains, private addresses, or unredacted screenshots.
- Keep `.env` local and commit only `.env.example`.
- Bind this lab to trusted interfaces and do not expose default ports directly to the internet.
- Replace example passwords before running outside an isolated workstation.
- Use least-privilege IAM roles and dedicated sandbox projects for cloud exercises.
- Treat dashboards and alert payloads as potentially sensitive operational data.

If a secret is committed, revoke it first, then remove it from Git history. Deleting only the latest file is not sufficient.
