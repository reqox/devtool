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

# Конфиг и данные nvim лежат по фиксированным путям, а не в $HOME.
# В рантайме UID/GID берутся у хоста, и записи в /etc/passwd для них нет,
# поэтому ни имя пользователя, ни его домашняя директория нам недоступны.
# XDG-переменные снимают эту зависимость: nvim сам добавляет к ним /nvim.
ENV XDG_CONFIG_HOME=/opt/nvim/config \
    XDG_DATA_HOME=/opt/nvim/data \
    XDG_STATE_HOME=/opt/nvim/state \
    XDG_CACHE_HOME=/opt/nvim/cache \
    SHELL=/bin/bash

COPY . /opt/nvim/config/nvim
# umask 000: всё, что создаёт сборка (плагины, mason-пакеты, парсеры),
# сразу получает права 666/777. Иначе пришлось бы chmod'ить отдельным слоем,
# а это дублирует в образе весь data-каталог.
RUN umask 000 && nvim --headless "+Lazy! sync" "+luafile /opt/nvim/config/nvim/build.lua" +qa

# Конфиг попал в образ через COPY с обычными правами, а state/cache nvim
# создаёт с режимом 700 — открываем их для любого UID. Это несколько
# килобайт, в отличие от data (он уже 777 благодаря umask 000).
# safe.directory нужен для плагинов внутри образа (они принадлежат root),
# иначе git в :Lazy ругается на dubious ownership; область — только пути образа.
RUN mkdir -p /opt/nvim/data /opt/nvim/state /opt/nvim/cache \
    && chmod -R a+rwX /opt/nvim/config /opt/nvim/state /opt/nvim/cache \
    && git config --system --add safe.directory '/opt/nvim/*'

CMD ["nvim"]
