# Ejemplos de Integraciones

<a id="table-of-contents"></a>
## Índice

1. [Ejemplos de Chrome](#chrome-examples)
2. [Ejemplos de VS Code](#vs-code-examples)
3. [Ejemplos de JetBrains](#jetbrains-examples)
4. [Ejemplos de Slack](#slack-examples)
5. [Ejemplos de tareas programadas](#scheduled-task-examples)
6. [Ejemplos de GitHub Actions](#github-actions-examples)
7. [Ejemplos de observabilidad](#observability-examples)
8. [Notas de selección de herramientas](#tool-selection-notes)

<a id="chrome-examples"></a>
## Ejemplos de Chrome

Usa Chrome cuando la respuesta dependa del navegador, no del sistema de archivos.

Probar un formulario local:

```text
Open localhost:3000, submit the login form with invalid input, and tell me whether the validation errors appear.
```

Depurar un error de consola:

```text
Open the dashboard page and check the console for errors when the page loads.
```

Extraer datos estructurados:

```text
Go to the product listings page, capture name, price, and availability for each item, and save the result as CSV.
```

<a id="vs-code-examples"></a>
## Ejemplos de VS Code

VS Code funciona mejor cuando Claude puede ver el archivo que ya estás editando.

Revisar código seleccionado:

```text
Explain the logic in the selected function and point out any edge cases I should verify.
```

Usar automatización del navegador desde el editor:

```text
@browser open localhost:3000 and check the console for errors
```

Retomar desde el panel:

```text
Continue the previous conversation and update the implementation plan for the auth flow.
```

<a id="jetbrains-examples"></a>
## Ejemplos de JetBrains

JetBrains es la mejor opción cuando el IDE ya controla el flujo de edición.

Abrir Claude desde el terminal:

```bash
claude
```

Conectar una sesión de terminal externa al IDE:

```text
/ide
```

Usar contexto de selección:

```text
Summarize the selected method and identify any assumptions that would be risky in production.
```

<a id="slack-examples"></a>
## Ejemplos de Slack

Slack es útil cuando la discusión ya contiene el contexto.

Convertir un bug report en una sesión de código:

```text
@Claude investigate the checkout failure described in this thread and open a fix plan.
```

Pedir una implementación rápida:

```text
@Claude implement the API validation change discussed above and summarize the files you touched.
```

Volver a modo código:

```text
Retry as Code
```

<a id="scheduled-task-examples"></a>
## Ejemplos de tareas programadas

Las tareas programadas son de alcance de sesión. Sirven para recordatorios y polling.

Revisar un despliegue cada cinco minutos:

```text
/loop 5m check whether the deployment finished and tell me what happened
```

Vigilar un PR:

```text
/loop 20m /review-pr 1234
```

Crear un recordatorio de una sola vez:

```text
remind me at 3pm to push the release branch
```

<a id="github-actions-examples"></a>
## Ejemplos de GitHub Actions

El patrón más reutilizable es mantener el prompt en un archivo separado y dejar el workflow acotado.

Esquema del archivo de prompt:

```markdown
## Anti-Hallucination Protocol
- Verify before reporting.
- Never invent line numbers.
- Never comment on files outside the diff.

## Review Output
- Must Fix
- Should Fix
- Can Skip
```

Ejemplo de trigger del workflow:

```yaml
on:
  pull_request:
    types: [opened, synchronize, ready_for_review]
  issue_comment:
    types: [created]
```

Ejemplo de prompt orientado a seguridad:

```text
Review this pull request for security issues only.
Focus on authentication, authorization, injection, secrets handling, unsafe defaults, and data exposure.
```

Ejemplo de triage de issues:

```text
Return strict JSON with labels, severity, duplicate_url, and comment_markdown.
```

<a id="observability-examples"></a>
## Ejemplos de observabilidad

La observabilidad responde qué pasó después de cerrar la sesión.

Listar sesiones recientes:

```bash
claude --resume
```

Revisar uso reciente:

```bash
session-stats.sh --range week
```

Inspeccionar lecturas repetidas de archivos:

```bash
jq -r 'select(.tool == "Read") | .file' ~/.claude/logs/activity-*.jsonl | sort | uniq -c | sort -rn
```

<a id="tool-selection-notes"></a>
## Notas de selección de herramientas

Usa Chrome para problemas de estado del navegador, VS Code o JetBrains para tareas centradas en código, Slack para contexto que ya vive en conversación, GitHub Actions para automatización repetible del repositorio, tareas programadas para loops de sesión y observabilidad para auditoría y costo. Si una tarea cruza límites de confianza, elige la integración más acotada que todavía resuelva el problema.
