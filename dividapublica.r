# Instale os pacotes necessários (caso ainda não tenha)
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(gganimate)) install.packages("gganimate")
if (!require(scales)) install.packages("scales")

# Carregar as bibliotecas
library(ggplot2)
library(gganimate)
library(scales)

# Dados
dados <- data.frame(
  AnoMes = factor(c("2022 Dez", "2023 Dez", "2024 Set", "2024 Out", "2024 Nov"),
                  levels = c("2022 Dez", "2023 Dez", "2024 Set", "2024 Out", "2024 Nov")),
  Saldo = c(5658017, 6612830, 7117367, 7133930, 7154437),
  PercentualPIB = c(56.1, 60.4, 61.7, 61.5, 61.2)
)

# Criar gráfico animado
grafico <- ggplot(dados, aes(x = AnoMes, group = 1)) +
  geom_line(aes(y = Saldo, color = "Saldo da Dívida (em milhões)"), size = 1.2) +
  geom_point(aes(y = Saldo, color = "Saldo da Dívida (em milhões)"), size = 3) +
  geom_line(aes(y = PercentualPIB * 100000, color = "% do PIB"), size = 1.2) +
  geom_point(aes(y = PercentualPIB * 100000, color = "% do PIB"), size = 3) +
  scale_y_continuous(
    limits = c(0, max(dados$Saldo) * 1.1),  # Eixo Y começa do zero
    labels = label_comma(),  # Formata os números com separadores de milhar
    name = "Saldo da Dívida (em milhões)",
    sec.axis = sec_axis(~ . / 100000, name = "% do PIB")
  ) +
  labs(
    title = "Evolução da Dívida Pública e Consumo do PIB",
    subtitle = "Dados de 2022 a 2024: https://www.bcb.gov.br/estatisticas/estatisticasfiscais",
    x = "Período",
    y = "Saldo da Dívida (em milhões)",
    color = "Legenda"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12)
  ) +
  scale_color_manual(values = c("Saldo da Dívida (em milhões)" = "blue", "% do PIB" = "red")) +
  transition_reveal(as.numeric(AnoMes))

# Configurar animação
animate(
  grafico,
  nframes = 100,  # Número total de frames
  fps = 10,       # Frames por segundo
  end_pause = 20  # Pausa no final da animação
)

# Salvar o gráfico animado
anim_save("evolucao_divida_formatado.gif")
