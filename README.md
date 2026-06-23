# cloudsmith-cli-action-test-binary

Demo of the [`cloudsmith-cli-action`](https://github.com/BartoszBlizniak/cloudsmith-cli-action)
(v3): install the **Cloudsmith CLI standalone binary** (no Python), authenticate via
**native OIDC**, and **push a Docker image** to a private Cloudsmith repo using the
CLI's **Docker credential helper** — on both **Linux** and **Windows**.

Pushing the image proves auth end-to-end, so there's a single workflow and no
separate `whoami` step.

## The whole thing

```yaml
permissions:
  id-token: write
  contents: read
env:
  CLOUDSMITH_ORG: ${{ vars.CLOUDSMITH_ORG }}
  CLOUDSMITH_SERVICE_SLUG: ${{ vars.CLOUDSMITH_SERVICE_SLUG }}
  IMAGE: docker.cloudsmith.io/bart-demo-org-terraform/claude-test-repo/hello-cloudsmith
steps:
  - uses: BartoszBlizniak/cloudsmith-cli-action@v3-poc      # install CLI + OIDC env
  - run: cloudsmith credential-helper install docker        # configure Docker creds
  - run: docker build -t "$IMAGE:linux" . && docker push "$IMAGE:linux"
```

After `credential-helper install`, `docker push` transparently fetches short-lived
credentials — **no token is ever saved or handled in the workflow.**

## Setup (what makes it work)

1. **Repo variables**: `CLOUDSMITH_ORG` = `bart-demo-org-terraform`,
   `CLOUDSMITH_SERVICE_SLUG` = `github-actions-cli-poc`.
2. **Cloudsmith OIDC binding** trusting GitHub's issuer for this repo
   (`repository: BartoszBlizniak/cloudsmith-cli-action-test-binary`, `aud: cloudsmith`),
   mapped to the `github-actions-cli-poc` service account (write access to
   `claude-test-repo`).

See [`.github/workflows/docker-publish.yml`](.github/workflows/docker-publish.yml).

## v2 vs v3

The `v2-action` branch does the same with `cloudsmith-io/cloudsmith-cli-action@v2`.
It needs an **extra manual step**: the action saves the exchanged JWT to
`CLOUDSMITH_API_KEY`, which you must then feed into `docker login` yourself before
pushing. v3's credential helper removes that step entirely.
