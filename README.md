# awscli-kubectl

Simple image containing Kubernetes / infra utilities, primarily for
connecting to AWS-based services.

- Fish shell + aliases
- AWS CLI
- Helm
- Kubie
- Kubeseal
- Talosctl
- OpenTofu

## Building

```bash
docker build . -t ghcr.io/spwoodcock/awscli-kubectl:latest
```

## Using

```bash
# Set alias, place in ~/.bashrc if you prefer
alias aws-shell='docker run --rm -it --name aws-cli \
  -v $PWD:$PWD \
  -v $HOME/.aws:/root/.aws \
  -v $HOME/.kube:/root/.kube \
  -v $HOME/.local/share/fish/fish_history:/root/.local/share/fish/fish_history \
  -v $HOME/.config/fish/config.fish:/opt/fish/user-config.fish:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --workdir $PWD \
  --network host \
  ghcr.io/spwoodcock/awscli-kubectl:latest'

# Source the alias (will be loaded at startup automatically in ~/.bashrc)
aws-shell
```
