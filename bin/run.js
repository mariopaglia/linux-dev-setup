#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

console.log('🚀 Linux Dev Setup - Universal Edition\n');

// Verificar se está rodando em Linux
if (process.platform !== 'linux') {
  console.error('❌ Este script funciona apenas em Linux!');
  console.error('   Distribuições suportadas: Ubuntu, Xubuntu, Linux Mint\n');
  process.exit(1);
}

// Caminho do script bash
const scriptPath = path.join(__dirname, '..', 'xubuntu-dev-setup.sh');

// Verificar se o script existe
if (!fs.existsSync(scriptPath)) {
  console.error('❌ Script não encontrado:', scriptPath);
  process.exit(1);
}

// Tornar o script executável
try {
  fs.chmodSync(scriptPath, '755');
} catch (err) {
  console.warn('⚠️  Aviso: Não foi possível tornar o script executável');
}

console.log('📦 Executando script de instalação...\n');
console.log('═'.repeat(50));
console.log('');

// Executar o script bash
const child = spawn('bash', [scriptPath], {
  stdio: 'inherit',
  shell: true
});

child.on('error', (error) => {
  console.error('\n❌ Erro ao executar o script:', error.message);
  process.exit(1);
});

child.on('exit', (code) => {
  if (code === 0) {
    console.log('\n✅ Script executado com sucesso!');
  } else {
    console.error(`\n❌ Script terminou com código de erro: ${code}`);
    process.exit(code);
  }
});
