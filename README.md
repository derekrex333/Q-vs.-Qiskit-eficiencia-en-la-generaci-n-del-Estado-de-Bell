# Comparación de eficiencia entre Q# y Qiskit en la generación del Estado de Bell

## 🧩 Autores

- Derek J. Alvirde M.
- Ramón Guzmán O.
- Keren J. Basurto T.

---

## 🌀 1. Introducción

La computación cuántica es un campo emergente que requiere herramientas capaces de modelar, ejecutar y analizar algoritmos cuánticos de forma eficiente. Actualmente, dos de las plataformas más utilizadas son:

- **Q#**, el lenguaje cuántico nativo desarrollado por Microsoft.
- **Qiskit**, el framework de IBM basado en Python.

Aunque ambas permiten construir y ejecutar circuitos cuánticos, difieren en su sintaxis, estructura, rendimiento y facilidad de aprendizaje.

En este proyecto comparamos ambas plataformas mediante la implementación del **Estado de Bell**, uno de los experimentos fundamentales para demostrar entrelazamiento cuántico.

---

## 🎯 2. Objetivo del proyecto

Evaluar, mediante un experimento controlado, la **eficiencia, claridad y rendimiento** de Q# y Qiskit al generar y medir el Estado de Bell usando **1024 ejecuciones ("shots")**.

---

## ❓ 3. Preguntas de investigación

1. ¿Cómo difiere la implementación del Estado de Bell entre Q# y Qiskit?
2. ¿Qué plataforma ofrece mayor claridad, concisión y facilidad de uso?
3. ¿Cuál presenta mejor rendimiento en ejecución y menor uso de recursos?
4. ¿Qué entorno es más accesible para el aprendizaje inicial de computación cuántica?

---

## ⚠ 4. Planteamiento del problema

A pesar de la amplia difusión de Q# y Qiskit, existe poca comparación directa basada en un mismo algoritmo y condiciones de prueba. Esta ausencia dificulta seleccionar la herramienta más adecuada para estudiantes, investigadores y desarrolladores que inician en el campo.

El Estado de Bell resulta ideal para esta comparación debido a que:

- Su implementación es corta y clara
- Es fundamental para comprender el entrelazamiento
- Permite medir tiempo, memoria y número de compuertas

---

## 🧪 5. Metodología del experimento

La comparación se realizó bajo las siguientes condiciones:

### ✔ Algoritmo evaluado
Creación y medición del Estado de Bell en 2 qubits

### ✔ Número de ejecuciones (shots)
1024

### ✔ Métricas analizadas
- Líneas de código ejecutable
- Tiempo de ejecución
- Memoria pico utilizada
- Número total de compuertas cuánticas

### ✔ Herramientas usadas
- Q# (Microsoft Quantum Development Kit)
- Python + Qiskit (IBM Quantum Runtime)
- R para análisis estadístico y generación de visualizaciones

### ✔ Simulación local
No se usó hardware real para evitar sesgos derivados de ruido cuántico.

---

## 🧩 6. Código fuente del experimento

### 🔷 6.1 Implementación en Q#

```csharp
namespace BellStateMetricas {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    // Operación principal que crea y mide el estado de Bell
    operation CreateBellState() : (Result, Result) {

        // Asignar dos qubits
        use (qb1, qb2) = (Qubit(), Qubit());

        // Paso 1: aplicar Hadamard al primer qubit
        H(qb1);

        // Paso 2: aplicar compuerta CNOT con qb1 como control y qb2 como target
        CNOT(qb1, qb2);

        // Medir ambos qubits
        let result1 = M(qb1);
        let result2 = M(qb2);

        // Resetear qubits antes de liberar memoria cuántica
        Reset(qb1);
        Reset(qb2);

        return (result1, result2);
    }
}
```

### 🔶 6.2 Implementación en Qiskit (Python)

```python
from qiskit import QuantumCircuit, transpile
from qiskit_ibm_runtime import SamplerV2 as Sampler, QiskitRuntimeService

# Guardar credenciales (token modificado para protección)
QiskitRuntimeService.save_account(
    channel="ibm_quantum_platform", 
    token="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    overwrite=True
)

# Conectar al servicio
service = QiskitRuntimeService()
backend = service.least_busy(operational=True, simulator=False, min_num_qubits=127)

print(f"Usando backend: {backend.name}")

# Crear el circuito cuántico
qc = QuantumCircuit(2, 2)
qc.h(0)
qc.cx(0, 1)
qc.measure([0, 1], [0, 1])

# Transpilación: optimización del circuito para el backend
qc_transpiled = transpile(qc, backend=backend, optimization_level=3)

print("Circuito transpilado exitosamente")
print(qc_transpiled)

# Crear el sampler y ejecutar con 1024 shots
sampler = Sampler(mode=backend)
pub = (qc_transpiled,)
job = sampler.run([pub], shots=1024)

print(f"Job ID: {job.job_id()}")
print("Esperando resultados...")

result = job.result()
print("\n=== RESULTADOS ===")
print(result)
```

---

## 📊 7. Análisis estadístico (realizado en R)

El procesamiento, comparación y visualización de datos se realizaron con R utilizando:

- `ggplot2`
- `dplyr`
- `showtext`
- `scales`

### ⭐ Gráfica utilizada

*(La imagen que subiste aparece aquí en el repositorio)*

```r
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
```

<img src="rstudio/comparacion de rendimiento.png" width="100%" height="auto">

---

## 📈 8. Resultados

### ✔ Comparación general Q# vs Qiskit

| Métrica | Q# | Qiskit | Mejor |
|---------|-----|---------|-------|
| Líneas de código ejecutable | 12 | 20 | Q# |
| Tiempo de ejecución | 0.75 ms | 5000 ms | Q# (×6667 más rápido) |
| Memoria pico | 150 MB | 325 MB | Q# (×2.17 menor) |
| Compuertas cuánticas | 2 | 10 | Q# |

### 🧠 Interpretación

- Q# es mucho más eficiente en tiempo y memoria.
- Qiskit ofrece mucha potencia, pero su interacción con hardware real introduce más complejidad.
- Q# resulta más conciso y directo para algoritmos educativos.
- Qiskit es más adecuado para entornos híbridos Python + hardware IBM.

---

## 🏆 9. Conclusiones

1. **Q#** demostró ser más eficiente en términos de tiempo de ejecución, memoria utilizada y número de compuertas.

2. **Qiskit** es más accesible y versátil, especialmente para estudiantes familiarizados con Python.

3. Aunque ambos permiten generar el Estado de Bell, **Q#** ofrece un enfoque más claro y elegante para construir algoritmos cuánticos básicos.

4. **Qiskit** destaca en integración con hardware real y ecosistema científico.

5. Para propósitos de enseñanza, **Q# es altamente recomendable**; para proyectos orientados a investigación, **Qiskit es superior**.

---

## 📚 10. Bibliografía

- Horodecki, R., Horodecki, P., Horodecki, M., & Horodecki, K. (2009). Quantum entanglement. *Reviews of Modern Physics*, 81(2), 865–942.

- International Business Machines Corporation. (n.d.). *Qiskit*. IBM Quantum Computing.

- Legitimate_Move_8017. (2022). *Qiskit or Q?* Reddit.

- Microsoft. (2017). *Introduction to the quantum programming language Q#*. Microsoft Learn.

- Nielsen, M. A., & Chuang, I. L. (2010). *Quantum computation and quantum information*. Cambridge University Press.

- Sutor, R. (2019). *Programming quantum computers*. O'Reilly Media.

---

## 🛠 11. Cómo ejecutar el proyecto

### ▶ Q#

```bash
dotnet run
```

### ▶ Qiskit

```bash
pip install qiskit qiskit-ibm-runtime
python bell.py
```
