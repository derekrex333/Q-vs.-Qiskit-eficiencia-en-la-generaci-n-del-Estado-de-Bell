library(ggplot2) 
library(dplyr) 
library(scales) 
library(sysfonts) 
library(showtext) 

# Fuentes elegantes
font_add_google("Roboto Condensed", "roboto") 
font_add_google("Source Sans Pro", "source") 
showtext_auto() 

# Datos
datos <- data.frame(
  Framework = rep(c("Q#", "Qiskit"), each = 4),
  Métrica = rep(c("Líneas de código\nejecutable",
                  "Tiempo de ejecución\n(ms)",
                  "Memoria pico\n(MB)",
                  "Número de\ncompuertas"), 2),
  Valor = c(12, 0.75, 150, 2,      # Q#
            20, 5000, 325, 10)     # Qiskit
)

datos$Framework <- factor(datos$Framework, levels = c("Q#", "Qiskit"))
datos$Métrica <- factor(datos$Métrica,
                        levels = c("Líneas de código\nejecutable",
                                   "Tiempo de ejecución\n(ms)",
                                   "Memoria pico\n(MB)",
                                   "Número de\ncompuertas"))

# Paleta profesional
colores <- c("Q#" = "#003087", "Qiskit" = "#4d4d4d")

# Gráfico con log10
p <- ggplot(datos, aes(x = Métrica, y = Valor, fill = Framework)) +
  geom_col(position = position_dodge(width = 0.82),
           width = 0.78, color = "white", size = 0.3) +
  
  geom_text(
    aes(label = ifelse(
      Valor < 1,
      sprintf("%.2f", Valor),
      prettyNum(Valor, big.mark = ",", decimal.mark = ".")
    )),
    position = position_dodge(width = 0.82),
    vjust = -0.6, size = 4.2, family = "roboto",
    fontface = "bold", color = "#1a1a1a"
  ) +
  
  scale_fill_manual(values = colores) +
  
  scale_y_log10(
    expand = expansion(mult = c(0, 0.18)),
    labels = scales::comma_format(accuracy = 1)
  ) +
  
  labs(
    title = "Comparación de rendimiento: Q# vs Qiskit\nGeneración del estado de Bell (2 qubits)",
    subtitle = "Simulación local • 1024 ejecuciones (shots) • Noviembre 2025",
    caption = "Escala logarítmica aplicada. Q# muestra ventajas significativas en tiempo de ejecución (×6667) y uso de memoria (×2.17).",
    x = NULL,
    y = "Valor medido (escala log)"
  ) +
  
  theme_minimal(base_family = "roboto", base_size = 13) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5,
                              margin = margin(b = 12), color = "#1a1a1a"),
    plot.subtitle = element_text(size = 12, color = "#4d4d4d", hjust = 0.5,
                                 margin = margin(b = 20)),
    plot.caption = element_text(size = 10.5, color = "#666666", hjust = 1,
                                margin = margin(t = 20)),
    
    axis.text.x = element_text(size = 12, face = "bold", color = "#1a1a1a"),
    axis.text.y = element_text(size = 11),
    axis.title.y = element_text(size = 12, margin = margin(r = 12)),
    
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#e0e0e0", size = 0.4),
    
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 12.5, face = "bold"),
    legend.margin = margin(b = 15),
    
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    plot.margin = margin(20, 40, 20, 20)
  )

print(p)


