# Guía de Commands

Los commands son la forma más rápida de convertir prompts repetidos en herramientas operativas estables. En Claude Code, la superficie de commands es más amplia que los slash prompts: los commands integrados gobiernan la sesión interactiva, los archivos de command empaquetan workflows repetibles, los prompts MCP pueden aparecer como commands, los keybindings reducen fricción y un status line puede exponer contexto de runtime de forma continua.

<a id="index"></a>
## Índice

- [Superficie de commands](#command-surface)
- [Commands integrados y custom](#built-in-and-custom-commands)
- [Modelo de autoría](#authoring-model)
- [Keybindings y status line](#keybindings-and-status-line)
- [Ejemplo completo: Command Workbench](#complete-example-command-workbench)
- [Validación y troubleshooting](#validation-and-troubleshooting)
- [Lista operativa](#operational-checklist)

<a id="command-surface"></a>
## Superficie de commands

El sistema de commands tiene cinco capas prácticas:

| Capa | Propósito | Ubicación típica |
| --- | --- | --- |
| Slash commands integrados | Control de sesión, memoria, permisos, selección de modelo y diagnóstico | Runtime de Claude Code |
| Commands de proyecto | Prompts compartidos y versionados con el repositorio | `.claude/commands/` |
| Commands de usuario | Commands personales disponibles en todos los proyectos | `~/.claude/commands/` |
| Commands de prompts MCP | Commands expuestos dinámicamente por servidores MCP conectados | Servidores MCP conectados |
| Ergonomía de soporte | Invocación más rápida y mejor visibilidad del contexto | `~/.claude/keybindings.json`, `.claude/settings.json`, scripts auxiliares |

Los commands integrados sirven para operar Claude Code. Los custom commands sirven para operar tu workflow. Esa distinción importa porque mantiene la intención del proyecto en archivos revisables, en lugar de esconderla en mensajes repetidos del chat.

<a id="built-in-and-custom-commands"></a>
## Commands integrados y custom

Los slash commands integrados cubren ciclo de vida de la sesión, ayuda, cambio de modelo, permisos, memoria, gestión de MCP y diagnósticos. Forman parte del runtime y conviene tratarlos como primitivas de control, no como archivos de workflow.

Los custom commands son archivos markdown cuyo nombre se convierte en el nombre del command. Son la herramienta adecuada cuando un equipo repite el mismo flujo de revisión, release o diagnóstico con suficiente frecuencia como para merecer una interfaz estable. Los commands de proyecto viven con el repositorio para que puedan revisarse y compartirse. Los commands de usuario viven en el home para que sigan siendo personales sin alterar el repositorio.

Los commands de prompts MCP amplían esa superficie. Cuando un servidor MCP publica prompts, Claude Code puede exponerlos como slash commands. Eso hace que MCP sea útil no solo para herramientas, sino también para prompts operativos reutilizables.

<a id="authoring-model"></a>
## Modelo de autoría

Un archivo de command es un documento markdown con frontmatter opcional más el cuerpo del prompt que Claude debe ejecutar. En la práctica, cuatro características son las más importantes.

| Característica | Por qué importa | Uso típico |
| --- | --- | --- |
| Frontmatter | Declara metadatos, elección de modelo, permisos de herramientas y pistas de argumentos | Mantener explícito el comportamiento |
| `$ARGUMENTS` | Inyecta valores que aporta el usuario | Números de PR, versiones, tickets |
| Ejecución con `!` | Mete contexto de runtime en el prompt antes de ejecutarlo | `git status`, `git log`, `gh pr view` |
| Referencias con `@` | Importa archivos o directorios al contexto del command | Prompts de review, planes, specs, plantillas |

La regla de autoría es simple: un command debe estrechar la tarea, no ampliarla. Un buen command deja claro qué entradas recibe, qué contexto carga, qué herramientas necesita y qué forma debe tener el resultado.

Eso es especialmente importante para commands que invocan shell. La ejecución de shell es útil, pero un command debería pedir solo los comandos que realmente necesita. Un `allowed-tools` demasiado amplio convierte un prompt reutilizable en una superficie de automatización sin límite.

<a id="keybindings-and-status-line"></a>
## Keybindings y status line

Los keybindings y el status line no crean commands nuevos, pero hacen que el sistema de commands sea materialmente más usable.

Los keybindings reducen fricción en el bucle interactivo. Funcionan mejor para acciones que ocurren constantemente: abrir un editor externo, buscar historial, cambiar de modo o mostrar transcript y todo state. El principio clave es la predictibilidad. Conviene usar un conjunto pequeño de bindings que encaje con el ritmo operativo del equipo.

El status line proporciona contexto pasivo. Un buen status line responde preguntas que de otro modo obligan a cambiar de foco: qué modelo está activo, qué directorio está en foco, si el directorio actual pertenece a un repositorio Git y cuánto contexto de ventana queda. Un mal status line intenta mostrarlo todo y se convierte en ruido visual.

<a id="complete-example-command-workbench"></a>
## Ejemplo completo: Command Workbench

Este ejemplo construye un workbench reutilizable para un repositorio que depende de revisión estructurada, coordinación de releases y verificación de seguridad. También agrega un status line de proyecto y un archivo de keybindings de usuario para que el sistema de commands sea práctico de usar y no solo algo definido en disco.

El mismo artefacto está materializado en `docs/commands/example/command-workbench/`.

### Qué se construye

El workbench tiene dos alcances:

- `project/` contiene commands compartidos del repositorio y configuración de status line para todos los contribuidores.
- `user-home/` contiene keybindings personales que aceleran la experiencia interactiva sin contaminar el repositorio.

El diseño mantiene el workflow compartido bajo control de versiones y la ergonomía personal fuera de él.

### Estructura de directorios

```text
command-workbench/
|-- README.md
|-- README.es.md
|-- project/
|   `-- .claude/
|       |-- commands/
|       |   |-- review-pr.md
|       |   |-- release/
|       |   |   `-- release-notes.md
|       |   `-- security/
|       |       `-- security-audit.md
|       |-- settings.json
|       `-- statusline.sh
`-- user-home/
    `-- .claude/
        `-- keybindings.json
```

### Orden de creación

1. Crea `project/.claude/commands/` y sus subdirectorios.
2. Agrega los archivos de commands compartidos.
3. Agrega `project/.claude/statusline.sh`.
4. Registra el status line en `project/.claude/settings.json`.
5. Agrega `user-home/.claude/keybindings.json`.
6. Agrega `README.md` para que el bundle documente cómo copiar los archivos a un entorno real.

### Guía archivo por archivo

`README.md` explica los dos alcances y sus destinos:

```md
# Command Workbench

This example separates shared repository commands from personal ergonomics.

- Copy `project/.claude/commands/` into your repository root.
- Copy `project/.claude/settings.json` and `project/.claude/statusline.sh` into the same repository-level `.claude/`.
- Copy `user-home/.claude/keybindings.json` into `~/.claude/keybindings.json`.

After copying, reopen Claude Code or trigger the relevant settings workflow so the runtime picks up the changes.
```

`project/.claude/commands/review-pr.md` crea un command de revisión de pull request:

```md
---
description: Review a pull request and return structured findings.
argument-hint: [pr-number-or-url]
allowed-tools: Bash(gh pr view:*), Bash(git diff:*), Read, Grep, Glob
model: sonnet
---

# Review Pull Request

Use the pull request reference in `$ARGUMENTS`. If no argument is supplied, review the current branch diff against the default branch.

## Context

- Pull request metadata: !`gh pr view $ARGUMENTS --json title,body,files,additions,deletions`
- Current diff: !`git diff --stat`

## Task

Review the changes with emphasis on correctness, regressions, security, and missing tests.

## Output

Return:

1. Summary
2. Approval status
3. Critical findings
4. Important suggestions
5. Positive highlights
```

`project/.claude/commands/release/release-notes.md` genera salidas de release a partir del historial Git:

```md
---
description: Generate release notes from commits and pull requests.
argument-hint: [version-or-range]
allowed-tools: Bash(git tag:*), Bash(git log:*), Bash(gh api:*), Read
model: sonnet
---

# Release Notes

Create three outputs for the release range identified by `$ARGUMENTS` or, if omitted, from the latest stable tag to `HEAD`.

## Context

- Latest stable tag: !`git tag --sort=-v:refname | head -n 1`
- Commit log: !`git log --oneline --no-merges -20`

## Task

Produce:

1. A changelog section
2. A release pull request body
3. A user-facing announcement

Separate user-facing changes from internal engineering work.
```

`project/.claude/commands/security/security-audit.md` empaqueta una auditoría de seguridad repetible:

```md
---
description: Audit repository and Claude Code configuration for high-risk security issues.
allowed-tools: Bash(rg:*), Bash(grep:*), Bash(find:*), Read, Grep, Glob
model: sonnet
---

# Security Audit

Run a structured audit across repository contents and Claude Code configuration.

## Task

Check for:

- exposed credentials
- unsafe shell patterns
- weak configuration boundaries
- missing validation around critical entry points

## Output

Return findings grouped as:

1. Critical
2. High
3. Medium
4. Recommended next actions
```

`project/.claude/statusline.sh` muestra modelo activo, directorio, rama Git y uso de contexto:

```bash
#!/bin/bash
set -euo pipefail

input="$(cat)"

model="$(printf '%s' "$input" | jq -r '.model.display_name')"
dir="$(printf '%s' "$input" | jq -r '.workspace.current_dir' | xargs basename)"
used="$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')"

branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  current_branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -n "$current_branch" ]; then
    branch=" | ${current_branch}"
  fi
fi

printf '[%s] %s%s | ctx %s%%\n' "$model" "$dir" "$branch" "$used"
```

`project/.claude/settings.json` registra el status line:

```json
{
  "statusLine": {
    "type": "command",
    "command": ".claude/statusline.sh",
    "padding": 1
  }
}
```

`user-home/.claude/keybindings.json` agrega shortcuts útiles sin modificar el repositorio:

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Global",
      "bindings": {
        "ctrl+t": "app:toggleTodos",
        "ctrl+o": "app:toggleTranscript"
      }
    },
    {
      "context": "Chat",
      "bindings": {
        "ctrl+g": "chat:externalEditor",
        "ctrl+s": "chat:stash"
      }
    }
  ]
}
```

### Notas de integración

- Los archivos de repositorio van bajo la `.claude/` del proyecto destino.
- Los keybindings de usuario van en el home del operador, en `~/.claude/`.
- El script de status line espera que `jq` esté disponible.
- Si quieres namespacing en la ayuda, conserva la estructura de subdirectorios de los commands.

### Notas de ejecución

Después de copiar los archivos:

1. Abre Claude Code dentro del repositorio.
2. Ejecuta `/help` y verifica que aparezcan los custom commands.
3. Dispara el status line enviando un mensaje o cambiando el estado de la conversación.
4. Prueba los shortcuts configurados en el contexto de chat.
5. Ejecuta un command como `/review-pr 123` o `/release-notes`.

### Resultado esperado

El repositorio gana commands estables de workflow, la sesión muestra contexto útil en el footer y el operador dispone de shortcuts livianos para interacciones comunes.

<a id="validation-and-troubleshooting"></a>
## Validación y troubleshooting

Valida el setup en este orden:

1. Confirma que los archivos de commands viven en el alcance correcto.
2. Abre `/help` y verifica que los nombres aparezcan como esperas.
3. Revisa que los commands con shell solo pidan las herramientas que realmente necesitan.
4. Confirma que el script de status line imprime exactamente una línea.
5. Verifica que el archivo de keybindings use contextos y acciones válidas.

Si un command no aparece, las causas más comunes son un directorio incorrecto, un nombre de archivo markdown inválido o frontmatter mal formado. Si el status line no actualiza, revisa la ruta del script y asegúrate de que sea ejecutable en el entorno destino. Si un keybinding se ignora, verifica que el binding esté asignado al contexto correcto.

<a id="operational-checklist"></a>
## Lista operativa

- Mantén los nombres de commands cortos y orientados a resultado.
- Ajusta el acceso a shell al mínimo necesario en el frontmatter.
- Usa commands para workflows repetibles, no para prompts de una sola vez.
- Mantén los commands de repositorio bajo control de versiones y los bindings personales fuera de él.
- Haz que el status line sea informativo, no ruidoso.
- Revisa la forma de salida de los commands como revisarías cualquier otro contrato de interfaz.
