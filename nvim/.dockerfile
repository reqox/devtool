FROM rust:1.99.1-trixie AS builder
RUN cargo install --locked --version 0.27.1 tree-sitter-cli
RUN rustup component add rustfmt


FROM node:24.22.1-trixie-slim
RUN corepack enable pnpm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /mnt/workspace

# В рантайме нужны только toolchain и rustup-прокси.
# Registry/git-кэш cargo в образ не тащим.
COPY --from=builder /usr/local/rustup /usr/local/rustup
COPY --from=builder /usr/local/cargo/bin /usr/local/cargo/bin

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    tar \
    ripgrep \
    fd-find \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    unzip \
    gzip \
    ca-certificates \
    && ln -s /usr/bin/fdfind /usr/bin/fd

ARG NVIM_VERSION=0.12.6
ARG NVIM_SHA256=474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87

RUN wget -O /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
    && echo "${NVIM_SHA256}  /tmp/nvim.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/nvim.tar.gz -C /opt \
    && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/bin/nvim \
    && rm /tmp/nvim.tar.gz

COPY . /root/.config/nvim
RUN nvim --headless "+Lazy! sync" "+luafile /root/.config/nvim/build.lua" +qa

CMD ["nvim"]
