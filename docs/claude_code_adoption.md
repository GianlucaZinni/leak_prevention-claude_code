
# Adopción / consejos sobre Claude Code

---

## Lo que aún no se sabe

Antes de profundizar, esto es lo que sigue siendo genuinamente incierto:

- **Tamaño óptimo de CLAUDE.md** — Algunos equipos / blogs hablan de que trabaja mejor con 10 líneas, otros con 100. No hay un ganador claro.
- **Patrones de adopción en equipos** — No está probado si la estandarización top‑down supera a la bottom-up.
  - Top-down: La empresa define una configuración estándar. (hooks, reglas, convenciones de prompts)
  - Bottom-up: Los desarrolladores empiezan a usar las features por su cuenta sin una política central.
- **Umbrales de gestión de contexto** — Los números 70% / 90% son heurísticas, no ciencia exacta.
- **Funcionalidades avanzadas** — MCP servers, hooks y agentes: no está claro cuándo el costo de configuración se justifica.

Si alguien afirma tener esto completamente resuelto, probablemente esté adelantado al resto… o este demasiado confiado.

---

## Lo que sí sabemos (datos empíricos)

Algunos patrones han surgido a partir de estudios y retrospectivas de equipos:

| Hallazgo | Datos | Implicación |
|---------|------|-------------|
| **El alcance es lo más importante** | 1–3 archivos: ~85% éxito, 8+ archivos: ~40% | Empezar pequeño y expandir gradualmente |
| **Punto óptimo de CLAUDE.md** | 4–8KB óptimo, >16KB reduce coherencia | Conciso > exhaustivo |
| **Límites de sesión** | 15–25 turnos antes de degradación | Reiniciar para nuevas tareas |
| **ROI en generación de scripts** | 70–90% ahorro de tiempo | Buen primer caso de uso |
| **Explorar antes de implementar** | +20–30% calidad de decisión | Pedir alternativas primero |
| **Promptear en inglés** | Claude Code esta entrenado en inglés | Utilizar traductor en caso de ser necesario |


Fuente: blog de ingeniería MetalBear, estudios de practicantes en arXiv y discusiones de ingeniería en Reddit (2024–2025).
