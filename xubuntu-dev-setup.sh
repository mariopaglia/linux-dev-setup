#!/bin/bash

################################################################################
# Script de Configuração Completa do Ambiente de Desenvolvimento Linux
# Autor: Claude Code / Mario Paglia
# Versão: 3.0 - Universal Edition
#
# Compatível com:
# - Ubuntu 24.04+ / Xubuntu 24.04+
# - Linux Mint 21+ (baseado em Ubuntu)
#
# Este script pode ser executado em qualquer distribuição compatível e irá:
# - Detectar a distribuição automaticamente
# - Detectar ferramentas já instaladas (idempotente)
# - Instalar ZSH, Oh My ZSH, Powerlevel10k
# - Instalar Docker, VS Code, Chrome, DBeaver
# - Instalar ferramentas Node.js (pnpm, yarn, TypeScript, NestJS, Prisma)
# - Baixar configurações personalizadas (.gitconfig, .p10k.zsh)
# - Configurar ambiente completo de desenvolvimento
#
# Uso:
#   bash xubuntu-dev-setup.sh
#   ou via npx: npx @SEU_USUARIO/linux-dev-setup
################################################################################

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detectar distribuição
DISTRO_ID=""
UBUNTU_CODENAME=""

# URLs dos gists
GITCONFIG_URL="https://gist.githubusercontent.com/mariopaglia/d3d7924b26657199ce3734ef8dd161a0/raw/b4c7152611bf4239c81d716c59d7475061275be6/.gitconfig"
P10K_URL="https://gist.githubusercontent.com/mariopaglia/e1a672a76757de40401cf4c61eb3450b/raw/f3d514d87b57cb491141da84f1899a7e24ac30c1/.p10k.zsh"

# Funções auxiliares
print_step() {
    echo -e "\n${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

package_installed() {
    dpkg -l | grep -qw "$1"
}

snap_installed() {
    snap list 2>/dev/null | grep -q "^$1 "
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID=$ID

        # Linux Mint usa UBUNTU_CODENAME, Ubuntu usa VERSION_CODENAME
        if [ "$DISTRO_ID" = "linuxmint" ]; then
            # Tentar /etc/linuxmint/info primeiro
            if [ -f /etc/linuxmint/info ]; then
                UBUNTU_CODENAME=$(grep "^UBUNTU_CODENAME" /etc/linuxmint/info | cut -d= -f2)
            fi
            # Fallback: UBUNTU_CODENAME do /etc/os-release (Linux Mint 21+)
            if [ -z "$UBUNTU_CODENAME" ]; then
                UBUNTU_CODENAME=$(grep "^UBUNTU_CODENAME" /etc/os-release | cut -d= -f2)
            fi
            # Último recurso: VERSION_CODENAME do /etc/os-release
            if [ -z "$UBUNTU_CODENAME" ]; then
                UBUNTU_CODENAME=${VERSION_CODENAME:-}
            fi
            if [ -z "$UBUNTU_CODENAME" ]; then
                print_error "Não foi possível detectar o codename Ubuntu base do Linux Mint"
                exit 1
            fi
            print_step "Detectado: Linux Mint (base Ubuntu $UBUNTU_CODENAME)"
        else
            UBUNTU_CODENAME=$(lsb_release -cs)
            print_step "Detectado: Ubuntu/Xubuntu $UBUNTU_CODENAME"
        fi
    else
        print_error "Não foi possível detectar a distribuição"
        exit 1
    fi
}

################################################################################
# INÍCIO DO SCRIPT
################################################################################

echo "======================================"
echo "  Configuração do Ambiente Xubuntu   "
echo "======================================"
echo ""
echo "Este script irá configurar seu ambiente de desenvolvimento completo."
echo "Algumas operações podem solicitar sua senha sudo."
echo ""
read -p "Deseja continuar? (s/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Instalação cancelada."
    exit 0
fi

# Detectar distribuição
detect_distro

################################################################################
# 1. ATUALIZAÇÃO DO SISTEMA
################################################################################

print_step "1/19 - Atualizando o sistema..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget unzip git
print_success "Sistema atualizado"

################################################################################
# 2. INSTALAÇÃO DO ZSH
################################################################################

print_step "2/19 - Instalando ZSH..."
if command_exists zsh; then
    print_warning "ZSH já instalado ($(zsh --version))"
else
    sudo apt install zsh -y
    print_success "ZSH instalado"
fi

################################################################################
# 3. INSTALAÇÃO DAS FONTES (Meslo Nerd Font e FiraCode)
################################################################################

print_step "3/19 - Instalando fontes para terminal..."

# Criar diretório de fontes do usuário
mkdir -p ~/.local/share/fonts

# Instalar MesloLGS NF (recomendada pelo Powerlevel10k)
if [ ! -f "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" ]; then
    echo "Baixando MesloLGS NF..."
    curl -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o "/tmp/MesloLGS NF Regular.ttf"
    curl -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o "/tmp/MesloLGS NF Bold.ttf"
    curl -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o "/tmp/MesloLGS NF Italic.ttf"
    curl -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o "/tmp/MesloLGS NF Bold Italic.ttf"
    mv /tmp/"MesloLGS NF"*.ttf ~/.local/share/fonts/
    print_success "MesloLGS NF instalada"
else
    print_warning "MesloLGS NF já instalada"
fi

# Instalar FiraCode Nerd Font
if ! fc-list | grep -qi "FiraCode"; then
    echo "Baixando FiraCode Nerd Font..."
    FIRA_VERSION="3.2.1"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v${FIRA_VERSION}/FiraCode.zip" -o /tmp/FiraCode.zip
    unzip -q -o /tmp/FiraCode.zip -d /tmp/FiraCode
    mv /tmp/FiraCode/*.ttf ~/.local/share/fonts/ 2>/dev/null || true
    rm -rf /tmp/FiraCode.zip /tmp/FiraCode
    print_success "FiraCode Nerd Font instalada"
else
    print_warning "FiraCode já instalada"
fi

# Atualizar cache de fontes
fc-cache -fv > /dev/null 2>&1
print_success "Fontes instaladas e cache atualizado"

################################################################################
# 4. INSTALAÇÃO DO OH MY ZSH
################################################################################

print_step "4/19 - Instalando Oh My ZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My ZSH já instalado"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My ZSH instalado"
fi

################################################################################
# 5. INSTALAÇÃO DO POWERLEVEL10K
################################################################################

print_step "5/19 - Instalando Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    print_warning "Powerlevel10k já instalado"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_success "Powerlevel10k instalado"
fi

################################################################################
# 6. INSTALAÇÃO DOS PLUGINS ZSH
################################################################################

print_step "6/19 - Instalando plugins ZSH..."

# zsh-autosuggestions
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ -d "$AUTOSUGGESTIONS_DIR" ]; then
    print_warning "zsh-autosuggestions já instalado"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
    print_success "zsh-autosuggestions instalado"
fi

# zsh-syntax-highlighting
SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
    print_warning "zsh-syntax-highlighting já instalado"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_HIGHLIGHTING_DIR"
    print_success "zsh-syntax-highlighting instalado"
fi

################################################################################
# 7. CONFIGURAÇÃO DO .zshrc
################################################################################

print_step "7/19 - Configurando .zshrc..."
if [ -f "$HOME/.zshrc" ]; then
    # Fazer backup
    BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.zshrc" "$BACKUP_FILE"
    print_warning "Backup criado: $BACKUP_FILE"

    # Atualizar tema
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

    # Atualizar plugins
    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting node npm docker)/' "$HOME/.zshrc"

    # Adicionar source do .zshrc.custom se não existir
    if ! grep -q ".zshrc.custom" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

# Configurações customizadas
if [ -f ~/.zshrc.custom ]; then
    source ~/.zshrc.custom
fi
EOF
    fi

    # Adicionar source do .p10k.zsh se não existir
    if ! grep -q ".p10k.zsh" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

# Powerlevel10k configuration
if [ -f ~/.p10k.zsh ]; then
    source ~/.p10k.zsh
fi
EOF
    fi

    print_success ".zshrc configurado"
else
    print_warning ".zshrc não encontrado (será criado na primeira execução do ZSH)"
fi

################################################################################
# 8. DOWNLOAD DA CONFIGURAÇÃO DO POWERLEVEL10K
################################################################################

print_step "8/19 - Baixando configuração do Powerlevel10k..."
if [ -f "$HOME/.p10k.zsh" ]; then
    BACKUP_FILE="$HOME/.p10k.zsh.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.p10k.zsh" "$BACKUP_FILE"
    print_warning "Backup do .p10k.zsh criado: $BACKUP_FILE"
fi

curl -fsSL "$P10K_URL" -o "$HOME/.p10k.zsh"
print_success "Configuração do Powerlevel10k baixada"

################################################################################
# 9. CONFIGURAÇÃO DO NPM GLOBAL PREFIX
################################################################################

print_step "9/19 - Configurando npm global prefix..."
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Adicionar ao PATH no .bashrc
if ! grep -q "npm-global/bin" "$HOME/.bashrc"; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
    print_success "PATH adicionado ao .bashrc"
else
    print_warning "PATH já configurado no .bashrc"
fi

# Exportar PATH para a sessão atual
export PATH=~/.npm-global/bin:$PATH

################################################################################
# 10. CRIAÇÃO DO ARQUIVO .zshrc.custom
################################################################################

print_step "10/19 - Criando .zshrc.custom..."
cat > "$HOME/.zshrc.custom" << 'EOF'
# Configurações customizadas do ZSH
# Este arquivo é carregado automaticamente pelo .zshrc

# NPM Global Path (para comandos instalados globalmente como claude, nest, etc)
export PATH=~/.npm-global/bin:$PATH

# Aliases úteis - Git
alias ll='ls -lah'
alias gs='git status'
alias gp='git pull'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gph='git push'
alias gpl='git pull'

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -af'

# Docker Compose aliases
alias dc='docker compose'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'
alias dcrestart='docker compose restart'
alias dcps='docker compose ps'

# NPM/PNPM/Yarn aliases
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nrd='npm run dev'
alias pi='pnpm install'
alias pr='pnpm run'
alias prd='pnpm run dev'
alias yi='yarn install'
alias yr='yarn run'

# PostgreSQL (Docker) aliases
alias pgstart='cd ~/projetos && docker compose up -d postgres'
alias pgstop='docker stop postgres-dev'
alias pgrestart='docker restart postgres-dev'
alias pgcli='docker exec -it postgres-dev psql -U postgres'
alias pglogs='docker logs -f postgres-dev'

# Navegação rápida
alias proj='cd ~/projetos'

# NestJS
alias nest-new='nest new'
alias nest-g='nest generate'

# Prisma
alias prisma-migrate='prisma migrate dev'
alias prisma-studio='prisma studio'
alias prisma-generate='prisma generate'

# Limpar terminal
alias c='clear'
alias cl='clear'
EOF

print_success ".zshrc.custom criado"

################################################################################
# 11. DOWNLOAD DO .gitconfig
################################################################################

print_step "11/19 - Baixando .gitconfig personalizado..."
if [ -f "$HOME/.gitconfig" ]; then
    BACKUP_FILE="$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.gitconfig" "$BACKUP_FILE"
    print_warning "Backup do .gitconfig criado: $BACKUP_FILE"
fi

curl -fsSL "$GITCONFIG_URL" -o "$HOME/.gitconfig"
print_success ".gitconfig baixado e configurado"

################################################################################
# 12. INSTALAÇÃO DO DOCKER
################################################################################

print_step "12/19 - Instalando Docker..."
if command_exists docker; then
    print_warning "Docker já instalado ($(docker --version))"
else
    # Remover versões antigas
    sudo apt remove docker docker-engine docker.io containerd runc -y 2>/dev/null || true

    # Instalar dependências
    sudo apt install ca-certificates curl gnupg lsb-release -y

    # Adicionar chave GPG do Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Adicionar repositório do Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Instalar Docker
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    print_success "Docker instalado"
fi

# Adicionar usuário ao grupo docker
if groups | grep -q docker; then
    print_warning "Usuário já está no grupo docker"
else
    sudo usermod -aG docker $USER
    print_success "Usuário adicionado ao grupo docker (requer logout/login)"
fi

################################################################################
# 13. INSTALAÇÃO DO VS CODE
################################################################################

print_step "13/19 - Instalando VS Code..."
if command_exists code; then
    print_warning "VS Code já instalado ($(code --version | head -1))"
else
    # Importar chave GPG da Microsoft
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    rm packages.microsoft.gpg

    # Adicionar repositório
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

    # Instalar VS Code
    sudo apt update
    sudo apt install code -y
    print_success "VS Code instalado"
fi

################################################################################
# 14. INSTALAÇÃO DO GOOGLE CHROME
################################################################################

print_step "14/19 - Instalando Google Chrome..."
if command_exists google-chrome; then
    print_warning "Google Chrome já instalado ($(google-chrome --version))"
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
    print_success "Google Chrome instalado"
fi

################################################################################
# 15. INSTALAÇÃO DO DBEAVER
################################################################################

print_step "15/19 - Instalando DBeaver Community..."

# Verificar se já está instalado (Snap ou Flatpak)
if snap_installed dbeaver-ce 2>/dev/null || flatpak list 2>/dev/null | grep -q dbeaver; then
    print_warning "DBeaver já instalado"
else
    # Tentar instalar via Snap primeiro
    if command_exists snap; then
        sudo snap install dbeaver-ce --classic
        print_success "DBeaver Community instalado via Snap"
    # Se Snap não disponível, tentar Flatpak
    elif command_exists flatpak; then
        flatpak install -y flathub io.dbeaver.DBeaverCommunity
        print_success "DBeaver Community instalado via Flatpak"
    # Se nenhum disponível, oferecer instalar Snap
    else
        print_warning "Snap não encontrado. Instalando Snap..."
        sudo apt install snapd -y
        sudo systemctl enable --now snapd
        sudo snap install dbeaver-ce --classic
        print_success "DBeaver Community instalado via Snap"
    fi
fi

################################################################################
# 16. INSTALAÇÃO DO NODE.JS
################################################################################

print_step "16/19 - Instalando Node.js 22 LTS..."
NODE_MAJOR=22
if command_exists node && node --version | grep -q "^v${NODE_MAJOR}\."; then
    print_warning "Node.js 22 já instalado ($(node --version))"
else
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
    sudo apt install -y nodejs
    print_success "Node.js instalado ($(node --version))"
fi

################################################################################
# 17. INSTALAÇÃO DE FERRAMENTAS NODE.JS
################################################################################

print_step "17/19 - Instalando ferramentas Node.js globais..."

# pnpm
if command_exists pnpm; then
    print_warning "pnpm já instalado ($(pnpm --version))"
else
    npm install -g pnpm
    print_success "pnpm instalado"
fi

# yarn
if command_exists yarn; then
    print_warning "yarn já instalado ($(yarn --version))"
else
    npm install -g yarn
    print_success "yarn instalado"
fi

# TypeScript
if command_exists tsc; then
    print_warning "TypeScript já instalado ($(tsc --version))"
else
    npm install -g typescript
    print_success "TypeScript instalado"
fi

# NestJS CLI
if command_exists nest; then
    print_warning "NestJS CLI já instalado ($(nest --version))"
else
    npm install -g @nestjs/cli
    print_success "NestJS CLI instalado"
fi

# Prisma
if [ -f "$HOME/.npm-global/bin/prisma" ]; then
    print_warning "Prisma já instalado"
else
    npm install -g prisma
    print_success "Prisma instalado"
fi

# create-next-app
if [ -f "$HOME/.npm-global/bin/create-next-app" ]; then
    print_warning "create-next-app já instalado"
else
    npm install -g create-next-app
    print_success "create-next-app instalado"
fi

################################################################################
# 17. CRIAÇÃO DA ESTRUTURA DE DIRETÓRIOS E DOCKER COMPOSE
################################################################################

print_step "18/19 - Criando estrutura de diretórios e Docker Compose..."
mkdir -p ~/projetos

if [ -f "$HOME/projetos/docker-compose.yml" ]; then
    print_warning "docker-compose.yml já existe em ~/projetos"
else
    cat > "$HOME/projetos/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres-dev
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
    print_success "docker-compose.yml criado em ~/projetos"
fi

################################################################################
# 18. DEFINIR ZSH COMO SHELL PADRÃO
################################################################################

print_step "19/19 - Definindo ZSH como shell padrão..."
if [ "$SHELL" = "$(which zsh)" ]; then
    print_warning "ZSH já é o shell padrão"
else
    chsh -s "$(which zsh)"
    print_success "ZSH definido como shell padrão"
    print_warning "IMPORTANTE: Faça logout completo e login novamente (não apenas abrir novo terminal)"
    print_warning "No Linux Mint, configure também o emulador de terminal:"
    print_warning "  Clique direito no terminal → Preferences → Command → Run a custom command: zsh"
fi

################################################################################
# FINALIZAÇÃO
################################################################################

echo ""
echo "======================================"
echo -e "${GREEN}✓ Instalação concluída com sucesso!${NC}"
echo "======================================"
echo ""
echo -e "${YELLOW}PRÓXIMOS PASSOS IMPORTANTES:${NC}"
echo ""
echo -e "1. ${BLUE}Fazer LOGOUT e LOGIN novamente${NC} para aplicar:"
echo "   - Grupo docker"
echo "   - ZSH como shell padrão"
echo ""
echo -e "2. ${BLUE}Verificar instalações:${NC}"
echo "   bash ~/verify-installations.sh"
echo ""
echo -e "3. ${BLUE}Iniciar PostgreSQL:${NC}"
echo "   cd ~/projetos && docker compose up -d"
echo "   ou simplesmente: pgstart"
echo ""
echo -e "4. ${BLUE}Configurações baixadas:${NC}"
echo "   ✓ .gitconfig (do seu gist)"
echo "   ✓ .p10k.zsh (configuração Powerlevel10k)"
echo "   ✓ .zshrc.custom (aliases e PATH)"
echo ""
echo -e "${GREEN}Ferramentas instaladas:${NC}"
echo "  ✓ ZSH + Oh My ZSH + Powerlevel10k"
echo "  ✓ Docker + Docker Compose"
echo "  ✓ VS Code"
echo "  ✓ Google Chrome"
echo "  ✓ DBeaver Community"
echo "  ✓ pnpm, yarn, TypeScript, NestJS CLI, Prisma"
echo ""
echo -e "${BLUE}Para usar este script em outro computador:${NC}"
echo "  curl -fsSL https://raw.githubusercontent.com/SEU_REPO/xubuntu-dev-setup.sh | bash"
echo ""
echo -e "${YELLOW}Não esqueça de fazer LOGOUT/LOGIN!${NC}"
echo ""
