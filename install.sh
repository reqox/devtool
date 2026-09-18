#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
DATE_SUFFIX=$(date +%Y%m%d_%H%M%S)
echo -e "${GREEN}==> Installing has been started...${NC}"

for cmd in git curl tmux nvim; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}Ошибка: Команда '$cmd' не найдена. Пожалуйста, установите её перед продолжением.${NC}"
        exit 1
    fi
done

echo "Clone repo..."
if [ -d "devtool" ]; then
    echo "Folder 'devtool' already exists, pulling updates..."
    git -C devtool pull
else
    git clone https://github.com/reqox/devtool.git
fi

if [ -f ~/.tmux.conf ]; then
    echo "Backup your .tmux.conf to .tmux.conf.bak_${DATE_SUFFIX}"
    mv ~/.tmux.conf ~/.tmux.conf.bak_${DATE_SUFFIX}
fi
echo "Apply .tmux.conf..."
cp ./devtool/tmux/.tmux.conf ~/.tmux.conf --verbose

if [ -d ~/.config/nvim ]; then
  echo "Backup your nvim config to nvim.bak_${DATE_SUFFIX}"
  mv ~/.config/nvim ~/.config/nvim.bak_${DATE_SUFFIX}
fi
echo "Apply nvim config..."
mkdir -p ~/.config/
cp -rv ./devtool/nvim ~/.config/nvim

echo -e "${GREEN}==> Installation completed successfully!${NC}"
