#################################################################################
#  Busca recursiva em arquivos Excel (.xlsx e .xlsm) por um termo específico
#               Script desenvolvido por Gabriel Santos
#################################################################################

# --- VERIFICAÇÃO E INSTALAÇÃO DE PACOTES ---
pacotes_necessarios <- c("readxl", "stringr")

for (pckg in pacotes_necessarios) {
  if (!require(pckg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("📦 O pacote '%s' não foi encontrado. Instalando...\n", pckg))
    install.packages(pckg, dependencies = TRUE)
    library(pckg, character.only = TRUE)
  }
}
# -------------------------------------------

xlsxfind <- function(termo = NULL, nivel = 99, exclude = "NADA", match = "exact", case_sensitive = FALSE) {
  
  # Se o usuário rodar apenas `xlsxfind()` sem argumentos, mostra a ajuda!
  if (is.null(termo)) {
    xlsxfind_help()
    return(invisible(NULL))
  }

  pasta_inicial <- getwd()
  
  cat(sprintf("🔍 Buscando por: '%s' | Nível max: %s | Ignorando: '%s' | Match: %s | Case Sensitive: %s\n", 
              termo, nivel, exclude, match, case_sensitive))
  cat(strrep("-", 80), "\n")
  
  # Lista todos os arquivos excel recursivamente
  arquivos <- list.files(path = pasta_inicial, pattern = "\\.(xlsx|xlsm)$", recursive = TRUE, full.names = TRUE)  
  for (arq in arquivos) {
    if (basename(arq) %>% str_starts("~\\$|\\.~lock")) next
    
    # Calcula a profundidade
    rel_path <- path.expand(arq) %>% str_replace(fixed(pasta_inicial), "")
    depth <- str_count(rel_path, "/")
    
    if (depth > nivel) next
    if (exclude != "" && str_detect(arq, fixed(exclude))) next
    
    tryCatch({
      abas <- excel_sheets(arq)
      for (aba in abas) {
        dados <- read_excel(arq, sheet = aba, col_names = FALSE, .name_repair = "minimal")
        
        for (i in 1:nrow(dados)) {
          linha <- as.character(dados[i, ])
          linha <- linha[!is.na(linha)]
          if (length(linha) == 0) next
          
          valores_compara <- if (!case_sensitive) tolower(linha) else linha
          termo_busca <- if (!case_sensitive) tolower(termo) else termo
          
          encontrou <- if (match == "exact") termo_busca %in% valores_compara else any(str_detect(valores_compara, fixed(termo_busca)))
          
          if (encontrou) {
            cat(sprintf("%s : %s : %s\n", basename(arq), aba, paste(linha, collapse = "  ")))
          }
        }
      }
    }, error = function(e) {
      cat(sprintf("Error: Unsupported file format: %s\n", basename(arq)))
    })
  }
}

# --- FUNÇÃO DE AJUDA OCULTA ---
xlsxfind_help <- function() {
  cat("\n", strrep("=", 80), "\n")
  cat("🚀 Função 'xlsxfind' - Ajuda e Instruções\n")
  cat("Autor: Gabriel Santos | GitHub: https://github.com/ecosantos/xlsxfind\n")
  cat(strrep("=", 80), "\n\n")

  cat("📢 CRÉDITOS:\n")
  cat("• Use à vontade, mas não se esqueça de manter os créditos ao autor Gabriel Santos.\n\n")

  cat("💡 EXEMPLOS DE USO NO R:\n\n")
  cat("1. Busca simples (padrão: exata, ignorando maiúsculas/minúsculas):\n")
  cat("   xlsxfind(\"TERMO\")\n\n")
  cat("2. Buscar limitando a profundidade das pastas (ex: até 2 níveis abaixo):\n")
  cat("   xlsxfind(\"TERMO\", nivel = 2)\n\n")
  cat("3. Buscar ignorando caminhos/pastas específicos:\n")
  cat("   xlsxfind(\"TERMO\", exclude = \"NOME_PASTA\")\n\n")
  cat("4. Busca com distinção de maiúsculas/minúsculas:\n")
  cat("   xlsxfind(\"TERMO\", case_sensitive = TRUE)\n\n")
  cat("5. Busca parcial (estilo 'contém'):\n")
  cat("   xlsxfind(\"TERMO\", match = \"partial\")\n")
  cat(strrep("-", 80), "\n\n")
}

# --- MENSAGEM DISCRETA DE CARREGAMENTO (Apenas uma linha no console) ---
message("✔️  Função 'xlsxfind' carregada com sucesso! Digite `xlsxfind()` sem argumentos para ver as instruções de uso.")