
## Quickstart

### Paso 1: crear configuración mínima

```bash
mkdir -p .claude
```

Crear `.claude/CLAUDE.md`:

```markdown
# Project: [nombre-del-proyecto]

## Stack
- Runtime: [Node 20 / Python 3.11 / etc.]
- Framework: [Next.js / FastAPI / etc.]

## Commands
- Test: `npm test` o `pytest`
- Lint: `npm run lint` o `ruff check`

## Convention
- [Una regla importante, ej: "TypeScript strict mode required"]
```

### Paso 2: verificar configuración

```bash
claude
```

Luego preguntar:

```
What's this project's test command?
```

**Correcto**: Claude responde el comando configurado.  
**Error**: CLAUDE.md no fue cargado — verificar la ruta.

---

### Paso 3: primera tarea real

```bash
claude "Review the README and suggest improvements"
```

Claude debería referenciar automáticamente el stack y convenciones.

---

## Ruta de aprendizaje autónoma

Si prefieres entender antes de configurar:

### Fase 1: modelo mental

Objetivo: comprender cómo opera Claude Code.

Claude funciona en un loop:

```
prompt → plan → execute → verify
```

Prueba completar tareas reales sin configuración inicial.

---

### Fase 2: gestión de contexto

Concepto general:

- Bajo uso → trabajar libremente
- Uso medio → ser más selectivo
- Uso alto → considerar `/compact`
- Cerca del límite → `/clear`

Probar revisar `/status` periódicamente.

---

### Fase 3: archivos de memoria

Precedencia:

```
.claude/CLAUDE.md  >  ~/.claude/CLAUDE.md
```

Crear un CLAUDE.md mínimo y verificar si Claude lo utiliza.

---

### Fase 4: extensiones (cuando aparezca fricción)

| Problema | Posible solución |
|----------|------------------|
| Tareas repetitivas | Crear un agente |
| Problema de seguridad | Crear un hook |
| Necesidad de herramientas externas | Usar MCP |
| IA repite errores | Agregar una regla específica |

Agregar complejidad solo cuando realmente se necesite.

---

## Verificaciones rápidas

### Instalación básica

```bash
claude --version
claude /status
claude /mcp
```

Si falla → ejecutar `claude doctor`.

---

### Configuración leída correctamente

Preguntar:

```
What's the test command for this project?
```

Si responde correctamente → CLAUDE.md cargado.

---

### Gestión de contexto

Señal positiva:

Has notado cuándo el contexto se llena y actuaste (`/compact` o `/clear`).

---

## Errores comunes

| Patrón | Qué ocurre | Alternativa |
|------|------------|-------------|
| Config grande copiada | Reglas ignoradas | Empezar pequeño |
| Over‑engineering | Tiempo en config, no en código | Usar templates |
| Sin convenciones compartidas | Confusión en equipo | Documentar lo esencial |
| Activar todo de golpe | Complejidad innecesaria | Activar cuando se necesite |

---

## Consideraciones según tamaño del equipo

### Solo o equipo pequeño (2–3)

Estructura típica:

```
./CLAUDE.md
~/.claude/CLAUDE.md
```

Evitar sobre‑ingeniería.

---

### Equipo medio (4–10)

```
./CLAUDE.md
./.claude/settings.json
~/.claude/CLAUDE.md
```

Separar:

| Compartido | Personal |
|-------------|----------|
| comandos | preferencias |
| convenciones | agentes |
| formato commit | flags |

---

### Equipo grande (10+)

```
./CLAUDE.md
./.claude/settings.json
./.claude/agents/
~/.claude/CLAUDE.md
```

Riesgo: **config drift** (divergencia de configuraciones).

---

## Despliegue empresarial (50+ desarrolladores)

Requiere gobernanza central.

### Fase 1 — Fundación

- repositorio de configuración compartida
- charter de uso de IA
- registro de MCPs
- hooks de seguridad globales

### Fase 2 — Adopción

- clasificar proyectos por tier
- bootstrap de configuraciones
- onboarding de ingeniería
- auditoría inicial

### Fase 3 — Optimización

- revisar falsos positivos de hooks
- gestionar requests de MCP
- agregar controles en CI/CD
- revisar registry trimestralmente

---

## Situaciones comunes

### Evaluando Claude Code

Pasos rápidos:

```
npm i -g @anthropic-ai/claude-code
claude
claude "Analyze this codebase architecture"
/status
```

Preguntas clave:

- ¿Claude entiende tu stack?
- ¿CLAUDE.md mejora resultados?
- ¿Tu equipo aprende gestión de contexto?

---

### Desacuerdo sobre configuración

| Capa | Responsable | Contenido |
|-----|-------------|----------|
| Repo CLAUDE.md | Equipo | stack y convenciones |
| Hooks | Seguridad | guardrails |
| ~/.claude | Individuo | preferencias |

---

### Claude repite errores

En lugar de muchas reglas:

Agregar **una regla específica**.

```
## Problema específico
Cuando hagas X evita Y.
Usar Z.
```

---

## Referencia rápida

### Comandos útiles

| Comando | Uso |
|--------|-----|
| /status | revisar contexto |
| /compact | comprimir contexto |
| /clear | reiniciar contexto |
| /plan | modo planificación |
| /model | cambiar modelo |

---

### Costos de modelos

| Modelo | Costo | Uso |
|--------|------|-----|
| Haiku | $ | tareas simples |
| Sonnet | $$ | desarrollo general |
| Opus | $$$ | análisis complejo |

La mayoría comienza con **Sonnet**.

---

*Esta guía refleja observaciones actuales, no mejores prácticas definitivas. El campo aún está evolucionando.*
