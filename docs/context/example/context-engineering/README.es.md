# Toolkit de Ingeniería de Contexto

Este ejemplo muestra un flujo completo para ensamblar y mantener contexto de proyecto. El bundle es intencionalmente pequeño para que la relación entre entradas, generación y validación quede clara.

Se incluyen companions en español para los archivos markdown orientados a humanos dentro de este bundle.

## Qué Hace

El toolkit ensambla un archivo de contexto específico del proyecto a partir de un perfil más una plantilla reutilizable. También aporta checks de presupuesto, drift y aprendizajes de sesión para que la configuración siga siendo mantenible.

## Mapa De Archivos

| Archivo | Propósito |
|---|---|
| `profile-template.yaml` | Perfil del desarrollador y selección de módulos |
| `skeleton-template.md` | Estructura inicial de `CLAUDE.md` |
| `assembler.ts` | Genera la salida final a partir del perfil y los módulos |
| `eval-questions.yaml` | Auditoría manual de calidad |
| `canary-check.sh` | Validación estructural |
| `ci-drift-check.yml` | Detección semanal de drift en CI |
| `context-budget-calculator.sh` | Estimación del presupuesto de contexto siempre activo |
| `rules/knowledge-feeding.md` | Captura aprendizajes útiles de sesión |
| `rules/update-loop-retro.md` | Prompt de retrospectiva para cerrar el ciclo |

## Cómo Usarlo

1. Empezar desde la plantilla de perfil y crear un perfil real.
2. Ajustar la plantilla skeleton para que coincida con el proyecto.
3. Ejecutar el assembler para generar el archivo de contexto final.
4. Revisar el presupuesto antes de agregar más reglas.
5. Ejecutar el canary check para detectar problemas obvios.
6. Agregar el workflow de drift a CI si el archivo debe mantenerse sincronizado.
7. Usar las plantillas de reglas después de sesiones que dejaron aprendizaje útil.

## Resultado Esperado

El resultado es un flujo durable de contexto con entradas claras, una salida generada y validación alrededor. Es fácil de inspeccionar, fácil de repetir y fácil de evolucionar.
