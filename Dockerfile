FROM bitnami/kubectl:1.33-debian-12 AS kubectl


FROM docker.io/debian:trixie-slim
# `less` is needed by some aws commands
# `jq' is generally useful for parsing json responses
RUN apt-get update --quiet \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --quiet --no-install-recommends \
        "curl" \
        "unzip" \
        "less" \
        "jq" \
        "ca-certificates" \
        "fish" \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    # AWS CLI
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip ./aws \
    # Helm
    && curl -L https://get.helm.sh/helm-v3.18.5-linux-amd64.tar.gz -o helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && chmod +x linux-amd64/helm \
    && mv linux-amd64/helm /usr/local/bin/ \
    && rm -rf helm.tar.gz linux-amd64 \
    # Kubie
    && curl -L https://github.com/sbstp/kubie/releases/download/v0.26.0/kubie-linux-amd64 -o kubie \
    && chmod +x kubie \
    && mv kubie /usr/local/bin/ \
    # Kubeseal (sealed secrets)
    && curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.31.0/kubeseal-0.31.0-linux-amd64.tar.gz -o kubeseal.tar.gz \
    && tar -xvzf kubeseal.tar.gz kubeseal \
    && chmod +x kubeseal \
    && mv kubeseal /usr/local/bin/ \
    && rm kubeseal.tar.gz \
    # Shell aliases
    && mkdir -p /root/.config/fish \
    && cat <<'EOF' >> /root/.config/fish/config.fish
alias k='kubectl'
alias kcc='kubie ctx'
alias ns='kubie ns'

function copy-secret
    kubectl get secret $argv[1] -o json \
    | jq 'del(.metadata["namespace","creationTimestamp","resourceVersion","selfLink","uid"])' \
    | kubectl apply -n $argv[2] -f -
end
EOF

# Kubectl
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/bin/kubectl

ENV SHELL=/usr/bin/fish
SHELL ["/usr/bin/fish", "-c"]
ENTRYPOINT ["fish", "-c"]
CMD [ "fish"]
