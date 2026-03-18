# Bundle de Ejemplo de Ingeniería de Contexto

Esta carpeta contiene el ejemplo concreto referenciado por la guía principal. Es un toolkit pequeño y reproducible para construir y mantener contexto de proyecto.

Se incluyen companions en español para los archivos markdown orientados a humanos, de modo que el bundle pueda revisarse en cualquiera de los dos idiomas.

## Contenido

- `context-engineering/README.md` explica el flujo de extremo a extremo.
- `context-engineering/profile-template.yaml` define la entrada por desarrollador.
- `context-engineering/skeleton-template.md` proporciona el esqueleto del archivo de contexto.
- `context-engineering/assembler.ts` genera el archivo final de contexto.
- `context-engineering/eval-questions.yaml` soporta auditorías manuales.
- `context-engineering/canary-check.sh` valida estructura y drift.
- `context-engineering/ci-drift-check.yml` ejecuta la detección automática de drift.
- `context-engineering/context-budget-calculator.sh` estima el costo del contexto siempre activo.
- `context-engineering/rules/knowledge-feeding.md` captura aprendizajes de sesión.
- `context-engineering/rules/update-loop-retro.md` aporta un prompt de retrospectiva.

## Orden Recomendado

1. Leer el README del toolkit.
2. Completar un perfil real.
3. Ajustar el skeleton al proyecto.
4. Generar el archivo final de contexto.
5. Ejecutar el calculador de presupuesto y el canary check.
6. Agregar el workflow de drift a CI.
7. Usar los prompts de retro y knowledge feed después de sesiones significativas.
