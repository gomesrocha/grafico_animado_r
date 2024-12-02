setwd("~/Downloads/R - Grafico animado")


library(ggplot2)
library(gganimate)
library(dplyr)
library(readr)

# 1. Maiores Vazamentos de Dados
vazamentos <- data.frame(
  Evento = c("Cam4 Data Breach (Mar 2020)", "Yahoo Data Breach (2017)*", 
             "National Public Data Breach (Apr 2024)", "Aadhaar Data Breach (Mar 2018)", 
             "Alibaba Data Breach (Jul 2022)", "First American Financial Corporation Data Breach (May 2019)", 
             "Verifications.io Data Breach (Feb 2019)", "LinkedIn Data Breach (Jun 2021)", 
             "Facebook Data Breach (Apr 2019)", "Yahoo Data Breach (2014)", 
             "Starwood (Marriott) Data Breach (Nov 2018)"),
  Registros = c(10.88, 3, 2.9, 1.1, 1.1, 0.885, 0.763, 0.7, 0.533, 0.5, 0.5)
)

# Ordenar os dados em ordem crescente
vazamentos <- vazamentos %>%
  arrange(Registros)

# Adicionar uma coluna para controle da animação
vazamentos$Order <- seq_along(vazamentos$Evento)

# Gráfico animado de maiores vazamentos
vazamento_plot <- ggplot(vazamentos, aes(x = reorder(Evento, Registros), y = Registros, fill = Evento)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Maiores Vazamentos de Dados da História",
    x = "Evento",
    y = "Registros Vazados (bilhões)"
  ) +
  theme_minimal() +
  transition_reveal(Order) +  # Transição suave barra por barra
  ease_aes('linear')

# Salvar a animação
animate(vazamento_plot, nframes = 150, fps = 10, end_pause = 30, width = 800, height = 600, renderer = gifski_renderer("vazamentos_animados.gif"))
# Dados de vazamentos por país (2022-2023)
vazamentos_pais <- data.frame(
  Ano = rep(c(2022, 2023), each = 20),
  Pais = c("United States", "Russia", "France", "Spain", "India", "Taiwan", "Australia", "Italy", 
           "United Kingdom", "Brazil", "Turkey", "China", "Czechia", "Mexico", "Germany", 
           "Poland", "Canada", "South Korea", "Colombia", "Indonesia"),
  Contas = c(30.87, 107.70, 20.58, 4.20, 12.28, 3.26, 3.51, 1.86, 3.40, 11.35, 3.57, 34.06, 
             1.10, 1.01, 4.58, 1.87, 1.88, 2.56, 2.79, 14.83, 
             96.75, 78.36, 10.49, 7.82, 5.34, 4.05, 3.54, 3.43, 3.30, 3.26, 3.20, 2.64, 
             2.17, 1.93, 1.82, 1.81, 1.78, 1.43, 1.43, 1.39)
)

# Gráfico animado de transição entre 2022 e 2023
vazamento_pais_plot <- ggplot(vazamentos_pais, aes(x = reorder(Pais, -Contas), y = Contas, fill = Pais)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Vazamentos de Dados por País ({closest_state})",
    subtitle = "Transição entre 2022 e 2023",
    x = "País",
    y = "Contas Vazadas (milhões)"
  ) +
  theme_minimal() +
  transition_states(Ano, transition_length = 2, state_length = 2) +  # Transição entre os anos
  enter_fade() + 
  exit_fade() +
  ease_aes('cubic-in-out')

# Salvar a animação
animate(vazamento_pais_plot, nframes = 100, fps = 10, end_pause = 20, width = 800, height = 600, renderer = gifski_renderer("vazamentos_pais_2022_2023.gif"))
