#!/bin/bash

# Script de Verificação das Instalações
# Execute com: bash verify-installations.sh

echo "======================================"
echo "Verificando instalações..."
echo "======================================"
echo ""

# Função para verificar comandos
check_command() {
    if command -v $1 &> /dev/null; then
        echo "✓ $1: $($1 $2 2>&1 | head -1)"
    else
        echo "✗ $1: não encontrado"
    fi
}

# Node.js ecosystem
echo "Node.js Ecosystem:"
check_command "node" "--version"
check_command "npm" "--version"
check_command "pnpm" "--version"
check_command "yarn" "--version"
echo ""

# Docker
echo "Docker:"
check_command "docker" "--version"
check_command "docker" "compose version"
echo ""

# Aplicativos
echo "Aplicativos:"
check_command "code" "--version"
check_command "google-chrome" "--version"
check_command "zsh" "--version"
echo ""

# Ferramentas de desenvolvimento
echo "Ferramentas de Desenvolvimento:"
check_command "tsc" "--version"
check_command "nest" "--version"
check_command "prisma" "--version"
echo ""

# DBeaver
echo "DBeaver:"
if snap list | grep -q dbeaver-ce; then
    echo "✓ dbeaver-ce: $(snap list dbeaver-ce | tail -1 | awk '{print $2}')"
else
    echo "✗ dbeaver-ce: não encontrado"
fi
echo ""

# Docker PostgreSQL
echo "Docker Containers:"
if docker ps 2>/dev/null | grep -q postgres; then
    echo "✓ PostgreSQL container está rodando"
    docker ps | grep postgres
else
    echo "ℹ PostgreSQL container não está rodando"
    echo "  Para iniciar: cd ~/projetos && docker compose up -d"
fi
echo ""

# Verificar grupo docker
echo "Permissões Docker:"
if groups | grep -q docker; then
    echo "✓ Usuário está no grupo docker"
else
    echo "✗ Usuário NÃO está no grupo docker"
    echo "  Faça logout/login para aplicar as mudanças"
fi
echo ""

# Verificar shell padrão
echo "Shell Padrão:"
current_shell=$(echo $SHELL)
if [[ $current_shell == *"zsh"* ]]; then
    echo "✓ Shell padrão: $current_shell"
else
    echo "ℹ Shell padrão: $current_shell"
    echo "  Faça logout/login para aplicar o ZSH como padrão"
fi
echo ""

# Verificar Oh My ZSH
echo "ZSH Configuração:"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ Oh My ZSH instalado"
else
    echo "✗ Oh My ZSH não encontrado"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "✓ Powerlevel10k instalado"
else
    echo "✗ Powerlevel10k não encontrado"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "✓ zsh-autosuggestions instalado"
else
    echo "✗ zsh-autosuggestions não encontrado"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "✓ zsh-syntax-highlighting instalado"
else
    echo "✗ zsh-syntax-highlighting não encontrado"
fi
echo ""

# Verificar diretório de projetos
echo "Estrutura de Diretórios:"
if [ -d "$HOME/projetos" ]; then
    echo "✓ ~/projetos existe"
    if [ -f "$HOME/projetos/docker-compose.yml" ]; then
        echo "✓ ~/projetos/docker-compose.yml existe"
    else
        echo "✗ ~/projetos/docker-compose.yml não encontrado"
    fi
else
    echo "✗ ~/projetos não existe"
fi
echo ""

echo "======================================"
echo "Verificação concluída!"
echo "======================================"
