# xlsxfind 🔍

Uma função em R desenvolvida para realizar buscas recursivas de termos específicos dentro de arquivos Excel (`.xlsx` e `.xlsm`) de forma rápida e prática, direto pelo console.

## ✨ Funcionalidades

- **Busca Recursiva:** Procura em todas as subpastas do seu diretório de trabalho atual.
- **Controle de Profundidade:** Limita a busca a um nível máximo de pastas para poupar tempo.
- **Filtro de Exclusão:** Ignora pastas ou arquivos específicos que contenham um determinado termo no nome.
- **Modos de Match:** Suporta busca exata (`exact`) ou busca parcial (`partial`, estilo "contém").
- **Case Sensitivity:** Opção para diferenciar ou ignorar maiúsculas e minúsculas.
- **Auto-Instalação:** Carrega e instala automaticamente as dependências necessárias (`readxl` e `stringr`).

---

## 🚀 Como usar

Você não precisa baixar ou clonar o repositório inteiro. Pode carregar a função diretamente no seu console do R utilizando o comando `source()` com o link do script bruto (*raw*):

```r
source("[https://raw.githubusercontent.com/ecosantos/xlsxfind/main/xlsxfind.R](https://raw.githubusercontent.com/ecosantos/xlsxfind/main/xlsxfind.R)")
