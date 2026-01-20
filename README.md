# 🚀 Linux Dev Setup - Universal Edition

> Script completo e automatizado para configurar ambiente de desenvolvimento em Ubuntu/Xubuntu/Linux Mint

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange.svg)](https://ubuntu.com/)
[![npm version](https://img.shields.io/badge/npm-3.0.0-blue.svg)](https://www.npmjs.com/package/@mariopaglia/linux-dev-setup)

## 📋 Índice

- [Sobre](#-sobre)
- [Características](#-características)
- [Instalação Rápida](#-instalação-rápida)
- [O que é instalado](#-o-que-é-instalado)
- [Uso](#-uso)
- [Documentação](#-documentação)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [FAQ](#-faq)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

## 🎯 Sobre

Este script automatiza a configuração completa de um ambiente de desenvolvimento moderno para Ubuntu/Xubuntu/Linux Mint, incluindo:

- Terminal customizado (ZSH + Oh My ZSH + Powerlevel10k)
- Ferramentas de containerização (Docker)
- IDEs e editores (VS Code)
- Navegadores (Google Chrome)
- Ferramentas de banco de dados (DBeaver, PostgreSQL)
- Ecossistema Node.js completo (pnpm, yarn, TypeScript, NestJS, Prisma)
- Configurações personalizadas (.gitconfig, .p10k.zsh)

**Universal**: Detecta automaticamente sua distribuição Linux (Ubuntu, Xubuntu ou Linux Mint).
**Idempotente**: Pode ser executado múltiplas vezes sem problemas.

## ✨ Características

- ✅ **Totalmente automatizado** - Uma linha de comando e pronto
- ✅ **Idempotente** - Detecta ferramentas já instaladas
- ✅ **Backups automáticos** - Preserva configurações existentes
- ✅ **Configurações personalizadas** - Baixa seus dotfiles do GitHub
- ✅ **Output colorido** - Interface amigável com cores e status
- ✅ **Portátil** - Funciona em qualquer Xubuntu/Ubuntu formatado
- ✅ **Bem documentado** - Documentação completa incluída

## 🐧 Distribuições Suportadas

- ✅ Ubuntu 24.04+ LTS
- ✅ Xubuntu 24.04+ LTS
- ✅ Linux Mint 21+ (Virginia, Vera, etc)
- ✅ Kubuntu 24.04+ LTS
- ⚠️  Outras distros baseadas em Ubuntu podem funcionar

O script detecta automaticamente sua distribuição e se adapta conforme necessário.

## ⚡ Instalação Rápida

### Opção 1: Via NPX (Recomendado)

```bash
npx @mariopaglia/linux-dev-setup
```

Ou se preferir instalar globalmente:

```bash
npm install -g @mariopaglia/linux-dev-setup
linux-dev-setup
```

### Opção 2: Via cURL (Alternativa)

```bash
curl -fsSL https://raw.githubusercontent.com/mariopaglia/linux-dev-setup/main/xubuntu-dev-setup.sh | bash
```

### Opção 3: Revisar antes de executar

```bash
# Download
curl -fsSL https://raw.githubusercontent.com/mariopaglia/linux-dev-setup/main/xubuntu-dev-setup.sh -o setup.sh

# Revisar
less setup.sh

# Executar
bash setup.sh
```

### Opção 4: Clone o repositório

```bash
git clone https://github.com/mariopaglia/linux-dev-setup.git
cd linux-dev-setup
bash xubuntu-dev-setup.sh
```

## 📦 O que é instalado

### Shell & Terminal
- **ZSH** - Shell moderno e poderoso
- **Oh My ZSH** - Framework para gerenciar configurações ZSH
- **Powerlevel10k** - Tema elegante e rápido
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting

### Desenvolvimento
- **Docker + Docker Compose** - Containerização
- **VS Code** - Editor de código
- **DBeaver Community** - Cliente universal de banco de dados
- **PostgreSQL** - Banco de dados (via Docker)

### Node.js Ecosystem
- **pnpm** - Gerenciador de pacotes rápido
- **yarn** - Gerenciador de pacotes alternativo
- **TypeScript** - JavaScript tipado
- **NestJS CLI** - Framework Node.js progressivo
- **Prisma** - ORM moderno
- **create-next-app** - Scaffold para Next.js

### Navegadores
- **Google Chrome** - Navegador web

### Configurações Personalizadas
- **.gitconfig** - Suas configurações Git
- **.p10k.zsh** - Configuração Powerlevel10k
- **.zshrc.custom** - Aliases e PATH customizados
- **docker-compose.yml** - PostgreSQL pronto para uso

### Aliases Úteis (40+)
- Git: `gs`, `ga`, `gp`, `gc`, `gl`
- Docker: `dps`, `dcup`, `dcdown`, `dclogs`
- PostgreSQL: `pgstart`, `pgstop`, `pgcli`, `pglogs`
- NPM: `ni`, `nr`, `ns`, `nt`, `nb`
- Navegação: `proj`, `ll`, `c`

## 🎯 Uso

### Após a instalação

1. **Fazer logout/login** (OBRIGATÓRIO)
   ```bash
   logout
   ```

2. **Verificar instalações**
   ```bash
   bash ~/verify-installations.sh
   ```

3. **Iniciar PostgreSQL**
   ```bash
   pgstart
   # ou
   cd ~/projetos && docker compose up -d
   ```

4. **Conectar ao PostgreSQL**
   ```bash
   pgcli
   # ou
   docker exec -it postgres-dev psql -U postgres
   ```

### Credenciais PostgreSQL (desenvolvimento)

- **Host**: localhost
- **Porta**: 5432
- **Usuário**: postgres
- **Senha**: postgres
- **Database**: dev

⚠️ **IMPORTANTE**: Estas são credenciais de desenvolvimento. NÃO use em produção!

## 📚 Documentação

O projeto inclui documentação completa na pasta `docs/`:

- **[COMECE-AQUI.txt](docs/COMECE-AQUI.txt)** - Início visual com todas as informações
- **[QUICK-START.md](docs/QUICK-START.md)** - Guia de início rápido
- **[README-XUBUNTU-SETUP.md](docs/README-XUBUNTU-SETUP.md)** - Documentação completa
- **[COMO-USAR-EM-OUTRO-PC.md](docs/COMO-USAR-EM-OUTRO-PC.md)** - Como distribuir o script
- **[RESUMO-FINAL.md](docs/RESUMO-FINAL.md)** - Resumo de tudo

## 📁 Estrutura do Projeto

```
xubuntu-dev-setup/
├── README.md                    # Este arquivo
├── xubuntu-dev-setup.sh         # Script principal (548 linhas)
├── verify-installations.sh      # Script de verificação
├── LICENSE                      # Licença MIT
├── .gitignore                   # Arquivos ignorados
└── docs/                        # Documentação
    ├── COMECE-AQUI.txt         # Início visual
    ├── QUICK-START.md          # Guia rápido
    ├── README-XUBUNTU-SETUP.md # Documentação completa
    ├── COMO-USAR-EM-OUTRO-PC.md # Guia de distribuição
    └── RESUMO-FINAL.md         # Resumo completo
```

## 🔧 Personalização

### Configurar seus próprios dotfiles

Edite as URLs no início do script `xubuntu-dev-setup.sh`:

```bash
# Linha ~17-18
GITCONFIG_URL="https://gist.githubusercontent.com/SEU_USUARIO/HASH/raw/.gitconfig"
P10K_URL="https://gist.githubusercontent.com/SEU_USUARIO/HASH/raw/.p10k.zsh"
```

### Adicionar/Remover ferramentas

O script está organizado em seções numeradas. Para:

- **Adicionar**: Crie uma nova seção seguindo o padrão existente
- **Remover**: Comente ou delete a seção correspondente

### Modificar aliases

Edite a seção que cria `.zshrc.custom` (por volta da linha 200).

## ❓ FAQ

### O script é seguro?

Sim! O script:
- Usa apenas repositórios oficiais
- Verifica chaves GPG
- Não contém senhas hardcoded
- Cria backups antes de sobrescrever arquivos
- Todo o código é open-source e pode ser revisado

### Posso executar múltiplas vezes?

Sim! O script é idempotente. Ele detecta ferramentas já instaladas e pula essas etapas.

### Funciona em outras distros Ubuntu?

Sim! Testado em:
- ✅ Xubuntu 24.04 LTS
- ✅ Ubuntu 24.04 LTS
- ✅ Kubuntu 24.04 LTS
- ✅ Linux Mint 21+ (Virginia, Vera, etc)

O script detecta automaticamente a distribuição e se adapta conforme necessário.

### Como atualizar minhas configurações?

Simplesmente re-execute o script. Ele:
1. Fará backup dos arquivos atuais
2. Baixará as versões mais recentes dos seus gists
3. Aplicará as novas configurações

### Docker não funciona sem sudo

Você fez logout/login? Isso é necessário para aplicar o grupo docker.

```bash
# Verificar
groups | grep docker

# Se não aparecer
sudo usermod -aG docker $USER
# Fazer logout/login novamente
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abrir um Pull Request

## 📦 Publicar no NPM

Se você quiser publicar sua própria versão no NPM:

1. Criar conta no [npmjs.com](https://www.npmjs.com)
2. Login via terminal:
   ```bash
   npm login
   ```
3. Atualizar o nome do pacote no `package.json`:
   ```json
   {
     "name": "@SEU_USUARIO/linux-dev-setup",
     ...
   }
   ```
4. Publicar:
   ```bash
   npm publish --access public
   ```

## 📝 Changelog

### v3.0 - Universal Edition (2026-01-20)
- ✅ Suporte a múltiplas distribuições (Ubuntu/Xubuntu/Linux Mint)
- ✅ Detecção automática de distribuição
- ✅ Instalação via NPX
- ✅ DBeaver com suporte Snap/Flatpak
- ✅ Docker adaptado para Linux Mint
- ✅ Estrutura NPM completa
- ✅ Script de teste de detecção

### v2.0 (2026-01-17)
- ✅ Script completamente reescrito
- ✅ Detecção inteligente de ferramentas instaladas
- ✅ Backups automáticos
- ✅ Output colorido
- ✅ Download automático de dotfiles
- ✅ Documentação completa

### v1.0 (2026-01-17)
- ✅ Versão inicial

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👤 Autor

**Mario Paglia**
- GitHub: [@mariopaglia](https://github.com/mariopaglia)
- Email: mpagliajr@gmail.com

## 🙏 Agradecimentos

- [Oh My ZSH](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Docker](https://www.docker.com/)
- [Claude Code](https://claude.com/claude-code) - Ferramenta que ajudou a criar este script

## 🌟 Star History

Se este projeto te ajudou, considere dar uma ⭐!

---

**Feito com ❤️ para a comunidade de desenvolvedores**
