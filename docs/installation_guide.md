
# 1. Instalación

Elige el método de instalación según tu sistema operativo:

```C
/*──────────────────────────────────────────────────────────────*/
/* Método universal      */ npm install -g @anthropic-ai/claude-code
/*──────────────────────────────────────────────────────────────*/
/* Windows (CMD)         */ npm install -g @anthropic-ai/claude-code
/* Windows (PowerShell)  */ irm https://claude.ai/install.ps1 | iex
/*──────────────────────────────────────────────────────────────*/
/* macOS (npm)           */ npm install -g @anthropic-ai/claude-code
/* macOS (Homebrew)      */ brew install claude-code
/* macOS (Script)        */ curl -fsSL https://claude.ai/install.sh | sh
/*──────────────────────────────────────────────────────────────*/
/* Linux (npm)           */ npm install -g @anthropic-ai/claude-code
/* Linux (Script)        */ curl -fsSL https://claude.ai/install.sh | sh
```

## Verificar instalación

```bash
claude --version
```

---

## Actualizar Claude Code

Mantener Claude Code actualizado para obtener nuevas funcionalidades, correcciones de errores y mejoras de modelo.

```bash
# Buscar actualizaciones
claude update

# Alternativa con npm
npm update -g @anthropic-ai/claude-code

# Verificar versión
claude --version

# Verificar estado del sistema
claude doctor
```

### Comandos de mantenimiento disponibles

| Comando | Propósito | Cuándo usar |
|--------|-----------|-------------|
| `claude update` | Buscar e instalar actualizaciones | Semanalmente o si aparecen problemas |
| `claude doctor` | Verificar el estado del auto‑actualizador | Después de cambios del sistema |
| `claude --version` | Mostrar versión actual | Antes de reportar errores |
| `claude auth login` | Autenticarse desde línea de comandos | CI/CD, devcontainers, scripts |
| `claude auth status` | Ver estado de autenticación | Confirmar cuenta activa |
| `claude auth logout` | Eliminar credenciales guardadas | Máquinas compartidas o limpieza de seguridad |

### Recomendaciones de frecuencia de actualización

- **Semanalmente**: revisar si hay nuevas versiones
- **Antes de trabajo importante**: asegurarse de tener la última versión
- **Después de cambios del sistema**: ejecutar `claude doctor`
- **Ante comportamientos extraños**: actualizar primero y luego diagnosticar

---

# Aplicación de Escritorio: Claude Code sin terminal

Claude Code está disponible en dos formatos:

1. **CLI** (línea de comandos) — enfoque principal de esta guía
2. **Pestaña Code en la aplicación Claude Desktop**

Ambos utilizan el mismo motor, pero la versión Desktop ofrece interfaz gráfica.

Disponible en **macOS y Windows** (no requiere Node.js).

### Funcionalidades adicionales del Desktop

| Función | Detalles |
|-------|---------|
| Revisión visual de diffs | Ver cambios en archivos antes de aceptarlos |
| Preview en vivo de la app | Claude inicia tu servidor de desarrollo y verifica cambios |
| Monitoreo de PR de GitHub | Puede corregir fallos de CI y hacer merge automático |
| Sesiones paralelas | Varias sesiones con worktrees aislados |
| Conectores | Integración con GitHub, Slack, Linear, Notion |
| Adjuntos de archivos | Permite adjuntar imágenes y PDFs |
| Sesiones remotas | Ejecutar tareas largas en la nube de Anthropic |
| Conexiones SSH | Acceder a máquinas remotas o contenedores |

---

### Funcionalidades exclusivas del CLI

- Uso de APIs de terceros
- Flags de scripting (`--print`, `--output-format`)
- `--allowedTools` / `--disallowedTools`
- Equipos de agentes
- `--verbose`
- Soporte Linux

---

## Configuración compartida

La versión Desktop y la CLI comparten configuración:

- `CLAUDE.md`
- servidores MCP (`~/.claude.json` o `.mcp.json`)
- hooks
- skills
- settings

Esto significa que la configuración de CLI se reutiliza automáticamente en Desktop.

### Migrar sesión a Desktop

```bash
/desktop
```

Solo disponible en **macOS y Windows**.

---

## Nota sobre servidores MCP

Los servidores MCP definidos en `claude_desktop_config.json` (usados por la pestaña Chat) son **distintos** de los usados por Claude Code.

Para usar MCP en Claude Code:

- `~/.claude.json`
- `.mcp.json` dentro del proyecto

---

# Primer inicio

```bash
cd tu-proyecto
claude
```

En el primer inicio:

1. Se te pedirá autenticarte con tu cuenta de Anthropic (Seleccionar API KEY (opción 2))
2. Deberás aceptar los términos de servicio
3. Claude Code indexará tu proyecto (puede tardar unos segundos si el repositorio es grande)

---

Nota: Claude Code requiere una **suscripción activa de Anthropic**.