# Security In Action

Esta guia traduce la postura de seguridad en componentes que un equipo puede instalar de verdad. En lugar de quedarse en principios, propone una combinacion concreta de hooks, plugin reusable, skill especializada y MCP aprobado para reducir riesgo en repositorios reales.

## Indice

1. [Cuando usar hooks, plugins, skills y MCP](#security-action-cuando-usar)
2. [Baseline minimo para cualquier repositorio](#security-action-baseline)
3. [Guardrails con hooks](#security-action-hooks)
4. [Plugin reusable para equipos](#security-action-plugin)
5. [Skill de revision de seguridad](#security-action-skill)
6. [MCP recomendado](#security-action-mcp)
7. [Orden de despliegue](#security-action-orden)
8. [Checklist de verificacion](#security-action-checklist)

<a id="security-action-cuando-usar"></a>
## Cuando usar hooks, plugins, skills y MCP

Cada pieza cumple una funcion distinta:

| Componente | Usalo cuando | No lo uses cuando |
|---|---|---|
| Hook | Necesitas enforcement automatico y repetible | La decision requiere demasiado juicio o contexto humano |
| Plugin | Quieres distribuir la misma politica en muchos repositorios | La necesidad es local y todavia experimental |
| Skill | Necesitas una revision guiada, profunda y accionable | Lo que buscas es bloquear o permitir automaticamente |
| MCP | Necesitas una herramienta externa confiable como SAST o documentacion fresca | El mismo objetivo se resuelve mejor con shell local o archivos del repo |

La regla practica es simple: bloquea con hooks, distribuye con plugins, analiza con skills y amplifica con MCP.

<a id="security-action-baseline"></a>
## Baseline minimo para cualquier repositorio

Si no tienes nada, empieza con este kit minimo:

```text
my-repo/
|-- .claude/
|   |-- settings.json
|   `-- hooks/
|       |-- pretooluse-security.sh
|       `-- posttooluse-secret-scan.sh
`-- .gitignore
```

### Archivo 1: `.claude/settings.json`

```json
{
  "permissions": {
    "deny": [
      "Read(./.env*)",
      "Edit(./.env*)",
      "Write(./.env*)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Bash(cat .env*)",
      "Bash(printenv*)",
      "Bash(env)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/pretooluse-security.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash|Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/posttooluse-secret-scan.sh"
          }
        ]
      }
    ]
  }
}
```

Este archivo hace dos cosas: niega accesos obvios a secretos y registra hooks para inspeccionar entradas y salidas.

### Archivo 2: `.claude/hooks/pretooluse-security.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)

if echo "$payload" | grep -qiE 'rm -rf /|chmod -R 777|curl .*\\|\\s*sh|ignore previous instructions'; then
  echo "Blocked: dangerous command or prompt-injection pattern detected." >&2
  exit 2
fi

exit 0
```

Este hook sirve para frenar comandos peligrosos y patrones de prompt injection antes de que se ejecuten.

### Archivo 3: `.claude/hooks/posttooluse-secret-scan.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)

if echo "$payload" | grep -qiE 'AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC) PRIVATE KEY-----|postgres://[^[:space:]]+:[^[:space:]]+@'; then
  echo "Warning: output may contain secrets. Review before continuing." >&2
fi

exit 0
```

Este hook no bloquea por defecto. Su trabajo es hacer visible una posible fuga antes de que la salida se copie o se comitee.

### Archivo 4: `.gitignore`

```gitignore
.env
.env.local
.claude/logs/
```

Esto evita que archivos sensibles o ruidosos terminen en git por accidente.

<a id="security-action-hooks"></a>
## Guardrails con hooks

Los hooks son la primera linea de accion porque ejecutan politica automaticamente. Un baseline razonable cubre tres momentos:

1. `PreToolUse` para bloquear comandos inseguros y patrones de inyeccion.
2. `PostToolUse` para escanear salidas y archivos modificados.
3. `SessionStart` para validar configuracion e integridad.

Si el equipo solo puede implementar una capa hoy, que sea esta.

<a id="security-action-plugin"></a>
## Plugin reusable para equipos

Cuando el mismo baseline debe repetirse en varios repositorios, empaquetalo como plugin. Un plugin de seguridad minimo puede verse asi:

```text
security-guardrails/
|-- .claude-plugin/
|   `-- plugin.json
|-- hooks/
|   |-- hooks.json
|   `-- pretooluse-security.sh
`-- skills/
    `-- security-review/
        `-- SKILL.md
```

### `.claude-plugin/plugin.json`

```json
{
  "name": "security-guardrails",
  "description": "Shared security controls for Claude Code sessions",
  "version": "1.0.0"
}
```

### `hooks/hooks.json`

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/pretooluse-security.sh"
          }
        ]
      }
    ]
  }
}
```

### `hooks/pretooluse-security.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)

if echo "$payload" | grep -qiE 'rm -rf /|chmod -R 777|curl .*\\|\\s*sh|ignore previous instructions'; then
  echo "Blocked by security-guardrails plugin." >&2
  exit 2
fi

exit 0
```

Hazlo ejecutable:

```bash
chmod +x hooks/pretooluse-security.sh
```

En una version productiva, el comando del hook debe apuntar a este script empaquetado o a otra ruta controlada por el plugin manager. La idea del ejemplo es que el plugin distribuya politica y logica juntas, no que dependa de un archivo extra no documentado.

<a id="security-action-skill"></a>
## Skill de revision de seguridad

No todo debe bloquearse automaticamente. Para revisiones profundas, agrega una skill especializada:

```text
skills/security-review/SKILL.md
```

```markdown
---
name: security-review
description: Review the current change set for secrets exposure, unsafe shell usage, dependency risk, and auth or data-flow regressions
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*)
---

# Security Review

Inspect the current changes with a security-first mindset.

Always check:
- secrets handling
- unsafe command execution
- auth and authorization changes
- dependency additions
- data exfiltration paths

Report concrete findings first, ordered by severity.
```

Usa esta skill cuando quieras evidencia y hallazgos, no solo enforcement mecanico.

<a id="security-action-mcp"></a>
## MCP recomendado

El MCP mas util para seguridad de codigo suele ser uno de analisis estatico. Un baseline razonable es Semgrep MCP:

```json
{
  "mcpServers": {
    "semgrep": {
      "command": "uvx",
      "args": ["semgrep-mcp"]
    }
  }
}
```

Usalo para:

1. Escaneo del patch final.
2. Deteccion de patrones inseguros recurrentes.
3. Integracion en revisiones guiadas por Claude.

No lo uses como sustituto de hooks ni de revision humana. Es una capa adicional.

<a id="security-action-orden"></a>
## Orden de despliegue

Implementa en este orden:

1. `permissions.deny` en `.claude/settings.json`
2. Hook `PreToolUse`
3. Hook `PostToolUse`
4. Skill `security-review`
5. Plugin reusable para equipos
6. MCP aprobado y auditado

Ese orden reduce riesgo rapido sin obligar a montar toda la plataforma el primer dia.

<a id="security-action-checklist"></a>
## Checklist de verificacion

Antes de dar la instalacion por buena, verifica esto:

1. Los hooks existen y son ejecutables.
2. Los secretos reales no viven en archivos versionados.
3. Los accesos prohibidos fallan con `exit 2`.
4. La skill de seguridad aparece y produce findings accionables.
5. El MCP aprobado funciona con credenciales de minimo privilegio.
6. El equipo sabe como desactivar o rotar un componente comprometido.

Si esos seis puntos pasan, ya tienes una base operativa seria y no solo recomendaciones teoricas.
