# awscli-kubectl

Simple image for connecting to an EKS Kubernetes cluster:
- Fish shell + aliases
- AWS CLI
- Helm
- Kubie

## Building

```bash
docker build . -t ghcr.io/spwoodcock/awscli-kubectl:latest
```

## Using

```bash
# Set alias, place in ~/.bashrc if you prefer
alias aws-shell='docker run --rm -it --network=host -v $HOME:/root --workdir /root ghcr.io/spwoodcock/awscli-kubectl:latest'

aws-shell
```
