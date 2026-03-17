
# Claude Code | Cheatsheet

## Comandos Esenciales

| Comando | Acción |
|--------|--------|
| `/help` | Ayuda contextual |
| `/clear` | Reiniciar conversación |
| `/compact` | Liberar contexto |
| `/status` | Estado de sesión + uso de contexto |
| `/context` | Desglose detallado de tokens |
| `/plan` | Entrar en Plan Mode (sin cambios) |
| `/execute` | Salir de Plan Mode (aplicar cambios) |
| `/model` | Cambiar modelo (sonnet / opus / opusplan) |
| `/insights` | Analíticas de uso + reporte de optimización |
| `/simplify` | Detecta sobre‑ingeniería en código modificado + auto‑arreglo |
| `/batch` | Refactors masivos mediante 5–30 agentes worktree en paralelo |
| `/teleport` | Teletransportar sesión desde web |
| `/tasks` | Monitorear tareas en background |
| `/remote-env` | Configurar entorno cloud |
| `/remote-control` | Iniciar sesión de control remoto |
| `/rc` | Alias de `/remote-control` |
| `/mobile` | Links de descarga de app móvil Claude |
| `/fast` | Activar modo rápido (2.5× velocidad, 6× costo) |
| `/voice` | Activar entrada por voz |
| `/btw [pregunta]` | Pregunta lateral sin contaminar el historial |
| `/loop [intervalo] [prompt]` | Ejecutar prompt repetidamente |
| `/stats` | Gráfico de uso y estadísticas |
| `/rename [nombre]` | Nombrar o renombrar sesión |
| `/copy` | Copiar bloque de código o respuesta |
| `/debug` | Diagnóstico sistemático |
| `/exit` | Salir |

---

## Atajos de Teclado

| Atajo | Acción |
|------|-------|
| `Shift+Tab` | Cambiar modo de permisos |
| `Esc` ×2 | Rewind / deshacer |
| `Ctrl+C` | Interrumpir |
| `Ctrl+R` | Buscar historial de comandos |
| `Ctrl+L` | Limpiar pantalla |
| `Tab` | Autocompletar |
| `Shift+Enter` | Nueva línea |
| `Ctrl+B` | Tareas en background |
| `Ctrl+F` | Matar agentes en background |
| `Alt+T` | Activar / desactivar thinking |
| `Space` (mantener) | Entrada por voz |
| `Ctrl+D` | Salir |

---

## Referencias a Archivos

```
@path/to/file.ts    → Referenciar archivo
@agent-name         → Invocar agente
!shell-command      → Ejecutar comando shell
```

| IDE | Atajo |
|-----|------|
| VS Code | `Alt+K` |
| JetBrains | `Cmd+Option+K` |

---

## Modos de Permisos

| Modo | Edición | Ejecución |
|------|---------|-----------|
| Default | Pregunta | Pregunta |
| acceptEdits | Automático | Pregunta |
| Plan Mode | No puede | No puede |
| dontAsk | Solo reglas permitidas | Solo reglas permitidas |
| bypassPermissions | Automático | Automático (solo CI/CD) |

---

## Memoria y Configuración (3 niveles)

| Nivel | Linux/macOS | Alcance | Git |
|-------|-------------|---------|-----|
| **Global** | `~/.claude/CLAUDE.md` | Tu PC | No |
| **Proyecto** | `/project/CLAUDE.md  ` | Equipo | Sí (idealmente) |
| **Proyecto** | `/project/.claude/# ` | Equipo | Sí (idealmente) |
| **Personal** | `/project/.claude/CLAUDE.md.local` | Usuario | No |

```
┌─────────────────────────────────────────────────────────────────┐
│                    MEMORY HIERARCHY                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ~/.claude/CLAUDE.md          (Global - Todos los proyectos)   │
│        │                                                        │
│        ▼                                                        │
│   /proyecto/CLAUDE.md           (Proyecto - Solo este)          │
│        │                                                        │
│        ▼                                                        │
│   /proyecto/.claude/CLAUDE.md   (Local - Prefs personales)      │
│                                                                 │
│ Todos los archivos se fusionan de forma aditiva.                │
│ En caso de conflicto: prevalece el archivo más específico.      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Para instrucciones personales no incluidas en Git, tiene dos opciones:**
- /project/.claude/CLAUDE.md (añadiendolo a .gitignore)
- /project/CLAUDE.md.local (ignorado automáticamente por convención)

## Estructura normal de Carpeta `.claude/`

```
.claude/
├── CLAUDE.md
├── settings.json
├── settings.local.json
├── agents/
├── commands/
├── hooks/
├── rules/
└── skills/
```

---

## Flujo de Trabajo Típico
```
1. Abrir consola / terminal / IDE / Web APP / Desktop APP
2. Iniciar sesión → Ejecutar comando: claude
3. Revisar contexto → /status
4. Plan Mode → Shift+Tab ×2
5. Describir tarea → prompt claro
6. Revisar cambios → leer diff
7. Aceptar/Rechazar → y/n
8. Verificar → ejecutar tests
9. Commit
10. /compact si contexto >70%
```
---

## Gestión de Contexto (CRÍTICO)

Vigilar `Ctx(u)` en el status.

| Contexto | Estado | Acción |
|---------|-------|------|
| 0–50% | Verde | Trabajar normal |
| 50–70% | Amarillo | Ser selectivo |
| 70–90% | Naranja | Ejecutar `/compact` |
| >90% | Rojo | Ejecutar `/clear` |

---

## Reglas de Oro

1. Revisar **siempre** los diffs antes de aceptar.
2. Usar `/compact` antes de superar 70% de contexto.
3. Ser específico (WHAT / WHERE / HOW / VERIFY).
4. Usar Plan Mode para tareas complejas.
5. Crear `CLAUDE.md` en cada proyecto.
6. Hacer commits frecuentes.
7. Saber qué datos se envían al modelo.

---

## Selección Rápida de Modelo

| Tarea | Modelo | Esfuerzo |
|-----|------|------|
| Texto estándar / cambiar nombre | Haiku | Bajo |
| Desarrollo / refactor | Sonnet | Medio |
| Arquitectura / seguridad | Opus | Alto |

---

## El Loop de interacción
Cada vez que se interactúa con Claude Code, este sigue el mismo patrón:

```
┌───────────────────────────────────────────────────────────────────────┐
│                        LOOP DE INTERACCION                            │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│        1. DESCRIBIR ──→ Explica lo que necesitas                      │
│              │                                                        │
│              ▼                                                        │
│        2. ANALIZAR ──→ Claude explora la base de código               │
│              │                                                        │
│              ▼                                                        │
│        3. PROPONER ──→ Claude sugiere cambios (diff)                  │
│              |                                                        │
│              ▼                                                        │
│        4. REVISAR ──→ Lee y evalúa                                    │
│              |                                                        │
│              ▼                                                        │
│        5. DECIDIR ──→ Aceptar / Rechazar / Modificar                  │
│              |                                                        │
│              ▼                                                        │
│        6. VERIFICAR ──→ Ejecutar pruebas, comprobar el comportamiento │
│              |                                                        │
│              ▼                                                        │
│        7. CONFIRMAR ──→ Guardar cambios (opcional)                    │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

---

## Funcionalidades Poco Conocidas (pero oficiales)

| Función | Desde | Descripción |
|--------|------|-------------|
| **Tasks API** | v2.1.16 | Listas de tareas persistentes con dependencias |
| **Background Agents** | v2.0.60 | Sub‑agentes que trabajan mientras programas |
| **Agent Teams** | v2.1.32 | Coordinación multi‑agente |
| **Auto‑Memories** | v2.1.32 | Contexto automático entre sesiones |
| **Session Forking** | v2.1.19 | Crear líneas de tiempo paralelas |
| **LSP Tool** | v2.0.74 | Navegación tipo IDE |
| **Voice Mode** | v2.1.x | Entrada por voz |
| **Remote Control** | v2.1.51 | Controlar sesión desde móvil |
| **/loop** | v2.1.71 | Scheduler recurrente |
| **Skill Evals** | Mar 2026 | Evaluación y mejora de capacidades |

---

## Recursos

- Documentación oficial: https://docs.anthropic.com/en/docs/claude-code
- Guía avanzada: https://claudelog.com
- Crear `CLAUDE.md` en cada proyecto

---

Autor: Florian BRUNIAUX
