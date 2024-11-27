# Definir o diretório de trabalho
setwd("~/Downloads/R - Grafico animado")

# Carregar os pacotes necessários
library(ggplot2)
library(gganimate)
library(dplyr)
library(readr)

# Ler o arquivo CSV com delimitador ";"
dados <- read_delim("./dashboard-fires-month-27-11-2024-16_29_32.csv", delim = ";")

# Verificar os dados (opcional)
head(dados)

# Renomear a coluna 'date' para evitar conflitos com a função date()
dados <- dados %>%
  rename(data = date)

# Separar ano e mês a partir da coluna 'data'
dados <- dados %>%
  mutate(
    ano = as.numeric(substr(data, 1, 4)),
    mes = as.numeric(substr(data, 6, 7))
  )

# Agrupar por ano, mês, estado (uf) e classe (class), somando os focuses
dados_agrupados <- dados %>%
  group_by(ano, mes, uf, class) %>%
  summarise(total_focuses = sum(focuses), .groups = "drop")

# Criar o gráfico animado
grafico <- ggplot(dados_agrupados, aes(x = uf, y = total_focuses, size = total_focuses, color = factor(mes))) +
  geom_point(alpha = 0.7) +
  scale_color_discrete(name = "Mês") +  # Adiciona legenda para o mês
  scale_size(range = c(2, 15)) +
  labs(
    title = "Focos de incêndio por ano e estado",
    subtitle = "Ano: {closest_state}",  # Variável dinâmica para exibir o ano
    x = "Estado",
    y = "Total de Focos",
    size = "Total de Focos"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1)  # Rótulos do eixo X em 90 graus
  ) +
  transition_states(
    states = ano,  # Define que a transição ocorre por ano
    transition_length = 4,  # Tempo da transição (mais lento)
    state_length = 2        # Duração do estado em cada ano
  ) +
  ease_aes('cubic-in-out') +  # Efeito de suavização
  annotate("text", x = 2, y = max(dados_agrupados$total_focuses) * 1.1, label = "", size = 8, color = "black", parse = TRUE)

# Exibir a animação no R
animate(grafico, width = 800, height = 600, fps = 10, duration = 20)

# Exportar a animação como GIF (opcional)
anim_save("grafico_animado.gif", grafico)
