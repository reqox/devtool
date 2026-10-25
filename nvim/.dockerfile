FROM rust:1.99.1-trixie AS builder
RUN cargo install --locked tree-sitter-cli
RUN rustup component add rustfmt


FROM node:24.22.1-trixie-slim
RUN corepack enable pnpm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /mnt/workspace

COPY --from=builder /usr/local/cargo /usr/local/cargo
COPY --from=builder /usr/local/rustup /usr/local/rustup

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && ln -s /usr/bin/fdfind /usr/bin/fd \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -xf nvim-linux-x86_64.tar.gz \
    && mv ./nvim-linux-x86_64 /usr/bin/nvim-linux \
    && ln -s /usr/bin/nvim-linux/bin/nvim /usr/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

COPY . /root/.config/nvim
RUN nvim --headless "+Lazy! sync" "+luafile /root/.config/nvim/build.lua" +qa

CMD ["nvim"]
