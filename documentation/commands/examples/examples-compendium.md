# Catalogo de Ejemplos de Slash Commands

Este archivo reune ejemplos completos, listos para copiar y adaptar. La idea no es enumerar variantes pequenas, sino mostrar patrones fuertes y bien estructurados para los casos mas utiles.

## Resumen ejecutivo

| Comando | Categoria | Side effects | Mejor uso |
|---|---|---|---|
| `/audit-codebase` | Auditoria | No | Medir salud tecnica del repo |
| `/catchup` | Contexto | No | Recuperar contexto despues de una pausa o `/clear` |
| `/explain` | Aprendizaje | No | Explicar codigo, flujo o arquitectura |
| `/git-worktree` | Operacion | Si, controlado | Crear entornos aislados por branch |
| `/plan-start` | Planeacion | Si, escribe plan | Disenar una implementacion antes de tocar codigo |
| `/review-pr` | Revision | No | Revisar una PR con findings priorizados |
| `/ship` | Release gate | No | Verificar readiness antes de deploy |
| `/security-audit` | Seguridad | No | Auditar repo y configuracion con score |

## Indice

1. [Audit Codebase](#1-audit-codebase)
2. [Catchup](#2-catchup)
3. [Explain](#3-explain)
4. [Git Worktree](#4-git-worktree)
5. [Plan Start](#5-plan-start)
6. [Review PR](#6-review-pr)
7. [Ship](#7-ship)
8. [Security Audit](#8-security-audit)
9. [Ideas rapidas para ampliar el catalogo](#9-ideas-rapidas-para-ampliar-el-catalogo)

## 1. Audit Codebase

### Que resuelve

Convierte una inspeccion amplia del repo en un score entendible, con hallazgos concretos y un plan de mejora por prioridad.

### Cuando usarlo

- al entrar a un proyecto nuevo
- antes de proponer una refactorizacion grande
- cuando quieres una foto tecnica y no solo impresiones sueltas

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Bash(rg:*), Bash(find:*), Bash(git ls-files:*), Bash(npm audit:*), Bash(pnpm audit:*), Bash(pytest:*)
argument-hint: [path] [--quick] [--category=<name>]
description: Audita la salud tecnica del proyecto y devuelve score, hallazgos y plan de mejora
---

# Audit Codebase

Audita el proyecto actual o la ruta indicada en `$ARGUMENTS` y devuelve un score de salud tecnica con prioridades claras.

## Process

1. Detecta el stack y el alcance.
2. Evalua al menos estas categorias: secrets, security, tests, dependencies, structure.
3. Si el usuario pidio una categoria concreta, enfocate en esa categoria y reduce el resto.
4. Prioriza hallazgos con evidencia concreta.
5. No modifiques archivos.

## Output Format

### Summary
- Scope
- Stack
- Overall score: X/10

### Scorecard
| Category | Score | Key finding |
|---|---|---|
| Secrets | X/10 | ... |
| Security | X/10 | ... |
| Tests | X/10 | ... |
| Dependencies | X/10 | ... |
| Structure | X/10 | ... |

### Critical Findings
- item con archivo o comando asociado

### Quick Wins
1. accion de menos de 30 minutos
2. segunda accion
3. tercera accion

### Progression Plan
1. Foundation
2. Solid
3. Excellent

## Guardrails

- Trata grep y patrones heuristicas como evidencia inicial, no como verdad absoluta.
- Si una herramienta externa no existe, continua con la mejor evidencia local disponible.
- Si no hay hallazgos fuertes, dilo explicitamente.

## Usage

/audit-codebase
/audit-codebase src/server
/audit-codebase --quick
/audit-codebase --category=tests
```

### Por que esta estructurado asi

| Decision | Motivo |
|---|---|
| Scorecard fija | Permite comparar corridas distintas |
| Categorias estables | Evita auditorias improvisadas |
| Quick wins | Convierte el analisis en accion |
| Guardrails contra falsos positivos | Muy importante en auditorias por patrones |

### Como adaptarlo

- si tu equipo trabaja por dominios, cambia las categorias
- si quieres scoring mas duro, agrega umbrales por severidad
- si prefieres backlog, reemplaza `Progression Plan` por `Backlog Proposal`

## 2. Catchup

### Que resuelve

Reconstruye el contexto reciente del proyecto a partir de git, cambios locales y marcadores de trabajo pendiente.

### Cuando usarlo

- despues de usar `/clear`
- cuando vuelves a un branch despues de varios dias
- cuando necesitas retomar rapido sin releer todo el historial

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(git branch:*), Bash(rg:*)
argument-hint: [tema] [--brief]
description: Recupera el contexto reciente del proyecto y propone el siguiente paso mas probable
---

# Catchup

Recupera el contexto de trabajo reciente usando git, cambios locales y marcadores de TODO.

## Process

1. Resume los ultimos commits relevantes.
2. Inspecciona cambios sin commitear y staged.
3. Busca TODO, FIXME, HACK y XXX en archivos tocados recientemente.
4. Si `$ARGUMENTS` contiene un tema, prioriza ese tema.
5. Si existe `--brief`, devuelve solo lo esencial.

## Output Format

### Context Restored
- Branch
- Last activity
- Scope

### Recent Work
1. commit o cambio relevante
2. commit o cambio relevante
3. commit o cambio relevante

### Uncommitted Changes
- archivo y resumen corto

### Outstanding TODOs
- archivo:linea -> pendiente

### Suggested Next Steps
1. accion mas probable
2. alternativa valida

## Usage

/catchup
/catchup auth
/catchup --brief
```

### Por que esta estructurado asi

- empieza por evidencia objetiva en git
- luego pasa a cambios no commiteados
- termina proponiendo continuidad
- funciona bien tanto para ti como para otra persona que retoma el branch

### Como adaptarlo

- agrega lectura de `CLAUDE.md` o docs de sprint si tu equipo las usa
- agrega filtro por autor si el repo es muy activo
- convierte `Recent Work` en tabla si quieres mas detalle

## 3. Explain

### Que resuelve

Explica codigo, conceptos o flujos con profundidad variable y sin quedarse en una descripcion superficial.

### Cuando usarlo

- para entender una funcion o modulo
- para documentar una decision tecnica
- para onboarding o pairing asincrono

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep
argument-hint: [archivo|funcion|concepto] [--simple|--deep|--learn]
description: Explica codigo, arquitectura o conceptos con el nivel de profundidad adecuado
---

# Explain

Explica el objetivo indicado en `$ARGUMENTS`. Puede ser un archivo, una funcion, un flujo o un concepto.

## Process

1. Determina si el objetivo es archivo, funcion, flujo o concepto.
2. Ajusta la profundidad segun `--simple`, default o `--deep`.
3. Si existe `--learn`, agrega notas pedagogicas y contexto.
4. Explica primero el para que, despues el como, y por ultimo los trade-offs.

## Output Format

### What It Does
- objetivo y responsabilidad

### How It Works
1. paso
2. paso
3. paso

### Key Decisions
| Decision | Why | Alternative |
|---|---|---|
| ... | ... | ... |

### Example Usage
- ejemplo de uso correcto o de flujo

### Related Code
- archivo relacionado y por que importa

### Learning Notes
- solo si el usuario pidio `--learn`

## Usage

/explain src/auth/middleware.ts
/explain handleWebhook in payments.ts
/explain --deep authentication flow
/explain --learn repository pattern
```

### Por que esta estructurado asi

| Parte | Valor |
|---|---|
| Separa `What It Does` de `How It Works` | Evita mezclar proposito con implementacion |
| Tabla de decisiones | Obliga a explicar por que algo existe |
| `--learn` | Sirve tanto para expertos como para gente nueva |

### Como adaptarlo

- agrega analogias si tu audiencia es junior
- agrega `Related Tests` si quieres usarlo como comando de onboarding
- cambia `Example Usage` por `Sequence Walkthrough` si el foco es un flujo

## 4. Git Worktree

### Que resuelve

Crea un workspace aislado por branch sin contaminar el working tree principal.

### Cuando usarlo

- para features medianos o grandes
- para trabajar varias ramas en paralelo
- para experimentar sin mover tu working tree principal

### Ciclo de vida sugerido

```mermaid
flowchart LR
    A[Crear worktree] --> B[Instalar o reutilizar dependencias]
    B --> C[Verificar baseline]
    C --> D[Implementar cambios]
    D --> E[Limpiar worktree al terminar]
```

### Archivo del comando

```markdown
---
allowed-tools: Bash(git worktree:*), Bash(git status:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(grep:*), Bash(ls:*), Bash(mkdir:*), Bash(pnpm install:*), Bash(npm install:*)
argument-hint: <branch> [--fast] [--isolated]
description: Crea un git worktree para una branch nueva con checks de seguridad y setup inicial
---

# Git Worktree

Crea un worktree aislado para la branch indicada en `$ARGUMENTS`.

## Process

1. Valida el nombre de la branch.
2. Detecta si existe `.worktrees/` o `worktrees/`.
3. Verifica que el directorio este ignorado por git.
4. Crea el worktree con `git worktree add`.
5. Si no existe `--fast`, instala dependencias o reutiliza las de la raiz.
6. Devuelve la ruta final y el estado del setup.

## Guardrails

- Nunca crear worktrees para nombres vacios o invalidos.
- Si el directorio no esta en `.gitignore`, detenerse y pedir confirmacion antes de seguir.
- `--isolated` significa instalacion fresca; si no, prioriza reutilizar dependencias.

## Output Format

### Worktree Ready
- Path
- Branch
- Dependency mode: shared | isolated
- Next check to run

### Notes
- advertencias sobre `.env`, migraciones o setup adicional

## Usage

/git-worktree feat/auth
/git-worktree fix/login-bug --fast
/git-worktree refactor/db-layer --isolated
```

### Por que esta estructurado asi

- protege el repo principal
- usa un directorio dedicado
- deja claro el trade-off entre velocidad y aislamiento
- agrega guardrails antes de tocar git

### Como adaptarlo

- agrega deteccion de package manager si tu equipo usa varios
- agrega un check de `.env.example`
- crea comandos companeros para status y cleanup si el workflow crece

## 5. Plan Start

### Que resuelve

Convierte una solicitud ambigua en un plan implementable, con decisiones, tareas y validaciones antes de escribir codigo.

### Cuando usarlo

- features no triviales
- cambios con impacto en varias capas
- trabajo que costaria caro rehacer

### Pipeline sugerido

```mermaid
flowchart LR
    A[Entender pedido] --> B[Aclarar ambiguedades]
    B --> C[Disenar arquitectura]
    C --> D[Definir tareas y pruebas]
    D --> E[Guardar plan]
```

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Write, Edit
argument-hint: [brief o path a PRD]
description: Analiza el pedido y genera un plan ejecutable con decisiones, tareas y test plan
---

# Plan Start

Analiza el pedido en `$ARGUMENTS` y produce un plan completo antes de escribir codigo.

## Process

1. Relee el brief o PRD.
2. Lista ambiguedades, edge cases y constraints.
3. Propone arquitectura y trade-offs.
4. Define tareas por capas o dependencias.
5. Define test plan e integration verification.
6. Escribe un archivo de plan dentro de `docs/plans/`.

## Output Format

### Summary
- que se va a construir
- por que

### Decisions
- decision
- razon
- trade-off

### Architecture
- componentes
- boundaries
- riesgos

### Tasks
1. capa base
2. capa dependiente
3. capa final

### Test Plan
- unit
- integration
- e2e si aplica

### Out of Scope
- lo que no entra en este plan

## Guardrails

- No escribir codigo de implementacion.
- No avanzar si hay ambiguedades criticas sin resolver.
- Si una decision es importante, dejarla explicitada en `Decisions`.

## Usage

/plan-start
/plan-start docs/prd-user-auth.md
/plan-start "agregar flujo de invitaciones"
```

### Por que esta estructurado asi

| Decision | Motivo |
|---|---|
| Separa decisiones de tareas | Evita esconder arquitectura dentro del checklist |
| Incluye out of scope | Reduce creep de alcance |
| Incluye test plan desde el inicio | Evita planes imposibles de validar |

### Como adaptarlo

- agrega ADRs si tu proyecto las usa
- agrega diagrama Mermaid si la feature es asincrona o distribuida
- agrega un paso de validacion humana antes de guardar el plan

## 6. Review PR

### Que resuelve

Estandariza la revision de una PR y obliga a devolver findings priorizados, no comentarios vagos.

### Cuando usarlo

- antes de pedir review humana
- para segunda opinion tecnica
- para auditar riesgo de una PR grande

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Bash(gh pr view:*), Bash(git diff:*), Bash(rg:*)
argument-hint: <pr-number|pr-url>
description: Revisa una pull request y devuelve findings priorizados por severidad
---

# Review PR

Revisa la PR indicada en `$ARGUMENTS` y devuelve findings concretos, ordenados por severidad.

## Process

1. Obtiene metadata de la PR.
2. Inspecciona los archivos cambiados.
3. Evalua code quality, functionality, security, tests y docs.
4. Devuelve findings con evidencia, no opiniones vagas.

## Output Format

### Summary
- scope de la PR
- complejidad estimada
- veredicto general

### Must Fix
- finding con archivo y motivo

### Should Fix
- improvement con razon

### Nice to Have
- sugerencia menor

### Questions
- dudas que bloquean confianza

## Guardrails

- No inventes patrones del proyecto sin verificarlos en el codigo.
- Solo usa "Must Fix" para bugs, seguridad o riesgo real.
- Si no hay hallazgos, dilo explicitamente.

## Usage

/review-pr 123
/review-pr https://github.com/org/repo/pull/123
```

### Por que esta estructurado asi

- obliga a priorizar
- evita "review theater" con comentarios sin severidad
- fuerza a citar evidencia
- mantiene separadas dudas, defects y mejoras

### Como adaptarlo

- agrega una seccion `Regression Risk`
- agrega checklist de performance si tu stack lo necesita
- agrega soporte para follow-up pass si el equipo revisa varias veces la misma PR

## 7. Ship

### Que resuelve

Funciona como gate final antes de deploy. Separa blockers, warnings y checks recomendados.

### Cuando usarlo

- antes de deploy a produccion
- antes de freeze
- como paso manual o automatico de CI

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Bash(git rev-parse:*), Bash(git diff:*), Bash(npm test:*), Bash(npm run:*), Bash(pnpm test:*), Bash(pnpm build:*), Bash(pnpm lint:*), Bash(pnpm typecheck:*), Bash(rg:*)
argument-hint: [--production|--staging|--quick]
description: Ejecuta un pre-deploy checklist y devuelve readiness real
---

# Ship

Evalua si el estado actual esta listo para deploy.

## Process

1. Ejecuta blockers: tests, lint, typecheck, build, secrets scan.
2. Ejecuta checks de prioridad alta: seguridad, console logs, TODOs, migraciones.
3. Si no existe `--quick`, agrega checks recomendados.
4. Devuelve veredicto final: READY TO SHIP o NOT READY.

## Output Format

### Ship Readiness Report
- Branch
- Commit
- Target

### Blockers
| Check | Status | Details |
|---|---|---|
| Tests | ... | ... |
| Lint | ... | ... |
| Typecheck | ... | ... |
| Build | ... | ... |
| Secrets | ... | ... |

### High Priority
- item y accion sugerida

### Recommended
- item y nota

### Action Items
1. accion mas urgente
2. segunda accion
3. tercera accion

## Guardrails

- Este comando no deploya. Solo verifica readiness.
- Si un blocker falla, el veredicto final debe ser `NOT READY`.
- Si no hay suficiente evidencia para un check, indicalo como `UNKNOWN`, no como `PASS`.

## Usage

/ship
/ship --production
/ship --quick
```

### Por que esta estructurado asi

| Parte | Valor |
|---|---|
| Blockers separados | Hace explicito que no todo pesa igual |
| `UNKNOWN` | Evita falsos positivos optimistas |
| Action items | Convierte el gate en secuencia de correccion |

### Como adaptarlo

- agrega smoke tests post-deploy
- agrega rollback checklist
- agrega revision de env vars por entorno

## 8. Security Audit

### Que resuelve

Hace una auditoria de seguridad mas completa que un grep rapido y devuelve un score de postura con plan de remediacion.

### Cuando usarlo

- antes de release importante
- al auditar configuracion de Claude Code + repo
- al revisar riesgo de integraciones o hooks

### Archivo del comando

```markdown
---
allowed-tools: Read, Glob, Grep, Bash(rg:*), Bash(find:*), Bash(npm audit:*), Bash(pnpm audit:*), Bash(pip-audit:*), Bash(cat:*)
argument-hint: [path] [--quick]
description: Ejecuta una auditoria de seguridad del proyecto y devuelve score, findings y remediacion
---

# Security Audit

Audita el proyecto actual o la ruta indicada en `$ARGUMENTS` y devuelve una evaluacion de postura de seguridad.

## Process

1. Revisa configuracion sensible, hooks, settings y archivos de memoria si existen.
2. Busca secrets, claves privadas y patrones de exfiltracion.
3. Evalua superficies de injection y dependencias vulnerables.
4. Puntua la postura total sobre 100.
5. Devuelve findings priorizados y plan de remediacion.

## Output Format

### Security Posture
- Score: XX/100
- Grade: A-F
- Scope

### Phase Results
| Phase | Score | Key finding |
|---|---|---|
| Config | ... | ... |
| Secrets | ... | ... |
| Injection | ... | ... |
| Dependencies | ... | ... |
| Hooks | ... | ... |

### Critical Findings
- finding, ubicacion y fix

### High Findings
- finding, ubicacion y fix

### Remediation Plan
1. accion prioritaria
2. accion prioritaria
3. accion prioritaria

## Guardrails

- Un match heuristico no implica explotacion real.
- Si falta una herramienta externa, sigue con evidencia local.
- Nunca marques `A` si existen hallazgos criticos abiertos.

## Usage

/security-audit
/security-audit .claude
/security-audit --quick
```

### Por que esta estructurado asi

- mezcla score con findings concretos
- separa fases, lo que ayuda a explicar de donde sale la nota
- fuerza remediacion y no solo deteccion

### Como adaptarlo

- agrega base de amenazas propia si tu equipo mantiene una
- agrega verificacion de MCPs o agentes internos
- divide `Dependencies` por ecosistema si tu repo es poliglota

## 9. Ideas rapidas para ampliar el catalogo

Si quieres seguir creciendo esta biblioteca, estas ideas encajan muy bien:

| Idea | Objetivo | Salida ideal |
|---|---|---|
| `/commit` | Proponer conventional commit para cambios staged | titulo, body, footer |
| `/generate-tests` | Generar tests a partir de codigo existente | test plan + archivo de tests |
| `/optimize` | Detectar bottlenecks y quick wins | impacto, esfuerzo, riesgo |
| `/refactor` | Encontrar deuda tecnica y violaciones SOLID | refactors priorizados |
| `/release-notes` | Transformar commits en changelog y anuncio | changelog + resumen ejecutivo |
| `/sonarqube` | Leer issues de calidad de una PR | top files, top rules, action plan |
| `/validate-changes` | Meter un gate LLM antes del commit | approve, review o reject |
| `/learn-teach` | Ensenar un concepto por niveles | definicion, ejemplo minimo, errores comunes |
| `/learn-quiz` | Verificar comprension | preguntas por nivel + feedback |
| `/learn-alternatives` | Comparar enfoques | tabla comparativa + recomendacion |

## Cierre

Los mejores slash commands no son los mas largos, sino los que:

- tienen un objetivo unico y claro
- restringen bien sus permisos
- piensan por fases
- devuelven una salida estable
- agregan guardrails donde hay riesgo

Si mantienes esas cinco reglas, puedes adaptar cualquiera de estos ejemplos a tu propio flujo sin perder claridad ni seguridad.
