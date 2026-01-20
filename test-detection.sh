#!/bin/bash

# Teste de detecção de distribuição

echo "=== Teste de Detecção de Distribuição ==="
echo ""

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Distribuição: $NAME"
    echo "ID: $ID"
    echo "Versão: $VERSION"
    echo ""

    if [ "$ID" = "linuxmint" ]; then
        if [ -f /etc/linuxmint/info ]; then
            UBUNTU_CODENAME=$(grep UBUNTU_CODENAME /etc/linuxmint/info | cut -d= -f2)
            echo "✓ Linux Mint detectado"
            echo "✓ Ubuntu base: $UBUNTU_CODENAME"
        else
            echo "✗ Arquivo /etc/linuxmint/info não encontrado"
        fi
    else
        UBUNTU_CODENAME=$(lsb_release -cs)
        echo "✓ Ubuntu/Xubuntu detectado"
        echo "✓ Codename: $UBUNTU_CODENAME"
    fi
else
    echo "✗ /etc/os-release não encontrado"
fi

echo ""
echo "=== Verificação de Gerenciadores de Pacotes ==="
echo ""

command -v snap &>/dev/null && echo "✓ Snap disponível" || echo "✗ Snap não disponível"
command -v flatpak &>/dev/null && echo "✓ Flatpak disponível" || echo "✗ Flatpak não disponível"

echo ""
echo "=== Teste Concluído ==="
