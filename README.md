# cloudsmith-cli-action-test-binary

Minimal demo of the [`cloudsmith-cli-action`](https://github.com/BartoszBlizniak/cloudsmith-cli-action)
(v3 PoC) installing the **Cloudsmith CLI standalone binary** — no Python, no `pip` —
and authenticating via **native OIDC** on both **Linux** and **Windows** runners.

The whole thing is one step plus two env vars:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  whoami:
    strategy:
      matrix:
        os: [ ubuntu-latest, windows-latest ]
    runs-on: ${{ matrix.os }}
    env:
      CLOUDSMITH_ORG: ${{ vars.CLOUDSMITH_ORG }}
      CLOUDSMITH_SERVICE_SLUG: ${{ vars.CLOUDSMITH_SERVICE_SLUG }}
    steps:
      - uses: BartoszBlizniak/cloudsmith-cli-action@v3-poc
      - run: cloudsmith whoami
```

## Setup (what makes it work)

1. **Repo variables** (Settings → Secrets and variables → Actions → Variables):
   - `CLOUDSMITH_ORG` = `bart-demo-org-terraform`
   - `CLOUDSMITH_SERVICE_SLUG` = `github-actions-cli-poc`
2. **Cloudsmith OIDC binding** trusting GitHub's issuer for this repo
   (`repository: BartoszBlizniak/cloudsmith-cli-action-test-binary`, `aud: cloudsmith`),
   mapped to the `github-actions-cli-poc` service account.

No `CLOUDSMITH_API_KEY` secret is stored — the CLI exchanges the GitHub OIDC token
for a short-lived Cloudsmith credential at runtime.

See [`.github/workflows/cloudsmith-cli.yml`](.github/workflows/cloudsmith-cli.yml).
