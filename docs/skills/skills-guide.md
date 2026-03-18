# Referencia de Arquitectura de Skills

Este directorio se entiende mejor como una biblioteca de patrones reutilizables de skills, no como un unico estilo de documentacion. Algunos skills orquestan flujos de varias etapas, otros exponen un comando determinista, otros empaquetan conocimiento de dominio, y otros proveen plantillas o scripts de apoyo. El hilo comun es que cada skill encapsula una capacidad acotada con un trigger claro, herramientas limitadas y un contrato de salida explicito.

## Indice

1. [Modelo mental](#skills-modelo-mental)
2. [Anatomia del paquete](#skills-anatomia)
3. [Frontmatter](#skills-frontmatter)
4. [Arquetipos](#skills-arquetipos)
5. [Principios operativos](#skills-principios)
6. [Como elegir el patron correcto](#skills-eleccion)
7. [Ejemplo completo implementable](#skills-ejemplo)
8. [Lista de calidad](#skills-lista-calidad)
9. [Que se considera un buen resultado](#skills-buen-resultado)

<a id="skills-modelo-mental"></a>
## Modelo Mental

Un skill no es solo un conjunto de instrucciones. Es un paquete pequeno de capacidad que combina metadatos de descubrimiento, guia operativa y recursos opcionales que solo se cargan cuando hacen falta. Los buenos skills facilitan el trabajo del modelo porque reducen la ambiguedad, restringen el conjunto de herramientas y convierten una solicitud vaga en un plan de ejecucion concreto.

```
Intencion del usuario
  -> descripcion del skill
  -> instrucciones focalizadas
  -> scripts, referencias y plantillas opcionales
  -> salida predecible
```

<a id="skills-anatomia"></a>
## Anatomia Del Paquete

| Capa | Proposito | Contenido tipico | Cuando debe existir |
|---|---|---|---|
| `SKILL.md` | Punto de entrada y contrato operativo | Frontmatter, guia de trigger, flujo, forma de salida | Siempre |
| `scripts/` | Operaciones deterministicas o repetibles | Inicializacion, empaquetado, validacion, transformacion, generacion | Cuando el flujo se beneficia de logica ejecutable |
| `references/` | Conocimiento de dominio denso | Reglas, mapeos, criterios de scoring, guia de stack | Cuando el skill necesita contexto estable |
| `assets/` | Recursos de salida | Plantillas, snippets, boilerplate, assets estaticos | Cuando el skill produce artefactos estructurados |
| `examples/` | Demostraciones de resultados esperados | Casos before/after, salidas de ejemplo, ejemplos resueltos | Cuando la salida puede prestarse a confusion |

La separacion importa porque no todo debe cargar en contexto al mismo tiempo. `SKILL.md` debe concentrarse en la decision y la secuencia. El material de dominio va en `references/`, las plantillas en `assets/`, y los ayudantes deterministas en `scripts/`.

<a id="skills-frontmatter"></a>
## Frontmatter

El frontmatter es la capa de enrutamiento del skill. Le dice al modelo que es el skill, cuando debe usarlo y que herramientas puede usar una vez activo.

| Campo | Significado | Guia |
|---|---|---|
| `name` | Identificador del skill | Usa un nombre corto en kebab-case que refleje la intencion |
| `description` | Texto principal de trigger | Incluye la tarea y las situaciones que deben activarlo |
| `allowed-tools` | Alcance de herramientas | Mantenlo tan acotado como lo permita el flujo |
| `context` | Contexto de ejecucion | Usa `fork` cuando la tarea deba correr aislada |
| `agent` | Tipo de subagente | Usalo cuando un contexto aislado se beneficie de un agente especializado |
| `argument-hint` | Ayuda de invocacion | Agregalo cuando el skill espere argumentos posicionales |
| `disable-model-invocation` | Control manual | Usalo para flujos con efectos colaterales que no deben autoactivarse |
| `user-invocable` | Visibilidad en el menu | Oculta conocimiento de fondo que no tenga sentido como comando de usuario |
| `tags` | Ayuda de descubrimiento | Usa etiquetas breves que coincidan con la forma en que la gente busca |

La descripcion es el campo mas importante. Debe sonar como algo que un usuario realmente pediria y ser lo bastante especifica como para no chocar con skills vecinos. Los permisos de herramientas deben ser igual de deliberados: los analisis de solo lectura no deberian poder escribir, y los flujos tipo comando no deberian recibir acceso amplio a shell salvo necesidad real.

<a id="skills-arquetipos"></a>
## Arquetipos De Skills

| Arquetipo | Mejor para | Forma tipica |
|---|---|---|
| Orquestador de flujo | Procesos multietapa con dependencias | Handoffs entre etapas, checkpoints y salidas explicitas |
| Comando determinista | Una accion con efectos claros | Invocacion corta, validacion, ejecucion, resumen de estado |
| Generador | Transformar material fuente en artefactos | Analizar entrada, aplicar reglas, emitir uno o mas archivos |
| Skill de referencia | Conocimiento de dominio y buenas practicas | Reglas, patrones, ejemplos, checklists |
| Analizador o auditor | Evaluacion, clasificacion, revision | Modelo de scoring, evidencia, recomendaciones |
| Scaffold de paquete | Crear o estandarizar skills | Estructura de carpetas, plantillas, scripts, validacion |

La distincion importante no es la etiqueta sino el contrato. Un orquestador de flujo debe definir fronteras entre etapas. Un generador debe definir artefactos de entrada y salida. Un analizador debe definir como puntua y que evidencia espera. Un scaffold debe definir las convenciones que crea.

<a id="skills-principios"></a>
## Principios Operativos

### Mantener el trigger especifico

Una buena descripcion de skill incluye la accion y el caso de uso. "Generate release notes from git commits" es mejor que "Help with releases" porque coincide con la intencion del usuario y le da al modelo una senal de activacion confiable.

### Separar razonamiento de ejecucion

Si la tarea puede fallar o mutar estado, valida los prerrequisitos antes de hacer algo irreversible. Lee primero las entradas, confirma las suposiciones despues, y solo luego escribe o lanza etapas descendentes. Esto es especialmente importante en flujos que tocan repositorios, artefactos de despliegue o contenido visible para usuarios.

### Usar recursos para profundidad, no para ruido

Si un flujo depende de un conjunto grande de reglas, manten el skill principal legible y mueve el detalle a `references/`. Si la salida tiene una forma estable, pon esa forma en una plantilla. Si una etapa es mecanica, preferi un script antes que un bloque grande de instrucciones.

### Tratar los checkpoints como parte del diseno

Los checkpoints humanos no son interrupciones. Son puntos de control que evitan comprometer el flujo demasiado pronto. Usalos cuando una etapa posterior dependa de una decision de framing, un titulo, un riesgo o cualquier decision subjetiva que no deba adivinarse.

### Preferir acceso minimo a herramientas

La mayoria de los skills solo necesita una porcion pequena de la superficie de herramientas. Los skills de lectura deben seguir siendo de lectura. Los skills que escriben deben escribir en un lugar conocido y seguir un contrato fijo. Si hace falta un comando de shell, explicalo como parte del diseno y no como accidente de implementacion.

<a id="skills-eleccion"></a>
## Como Elegir El Patron Correcto

| Si la tarea es... | Preferi... | Por que |
|---|---|---|
| Multietapa con salidas dependientes | Orquestador | Las fronteras entre etapas forman parte del valor |
| Transformacion deterministica repetible | Generador + script | La repeticion debe hacerla la maquina |
| Principalmente conocimiento y reglas | Skill de referencia | El contexto debe cargarse solo cuando haga falta |
| Un comando que el usuario invoca directo | Skill estilo comando | La accion debe ser obvia y explicita |
| Auditoria, revision o scoring | Skill analizador | Los resultados deben ser explicables y respaldados por evidencia |
| Empaquetar una capacidad reutilizable | Scaffold | La estructura y las convenciones importan mas que la prosa |

<a id="skills-ejemplo"></a>
## Ejemplo Completo

Este ejemplo crea un skill funcional de release notes con cuatro archivos concretos. El skill no solo explica una idea: define el paquete, la referencia de clasificacion, una plantilla de salida y un script de apoyo para recolectar commits.

### Lo que vas a crear

```text
release-notes-generator/
|-- SKILL.md
|-- references/
|   `-- commit-categories.md
|-- assets/
|   `-- changelog-template.md
`-- scripts/
    `-- collect-commits.sh
```

### Archivo 1: `SKILL.md`

Este es el punto de entrada del skill. Debe vivir en la raiz del paquete.

```markdown
---
name: release-notes-generator
description: Generate release notes, changelog sections, and stakeholder summaries from git history
allowed-tools: Read, Write, Grep, Glob, Bash(git log:*), Bash(git diff:*), Bash(bash scripts/collect-commits.sh:*)
---

# Release Notes Generator

Generate release-ready notes from a git range.

Workflow:
1. Ask for the release range if it was not provided.
2. Run `bash scripts/collect-commits.sh <start-ref> <end-ref>` to gather the commit list.
3. Classify each entry using `references/commit-categories.md`.
4. Render the final output using `assets/changelog-template.md`.

Outputs:
- changelog section
- release PR summary
- stakeholder update
```

Este archivo define el trigger, las herramientas permitidas y el flujo obligatorio.

### Archivo 2: `references/commit-categories.md`

Este archivo contiene la clasificacion estable que el skill usa para no improvisar.

```markdown
# Commit Categories

## feature
- add
- introduce
- new
- support

## fix
- fix
- resolve
- patch
- correct

## performance
- optimize
- speed up
- reduce latency

## security
- harden
- sanitize
- validate
- restrict

## breaking-change
- remove
- rename public API
- incompatible
```

Sin esta referencia, el skill tiende a clasificar por intuicion. Con esta referencia, clasifica con un criterio repetible.

### Archivo 3: `assets/changelog-template.md`

Este archivo fija la forma final de la salida principal.

```markdown
# Release {{version}}

## Highlights
{{highlights}}

## Fixes
{{fixes}}

## Performance
{{performance}}

## Security
{{security}}

## Breaking Changes
{{breaking_changes}}
```

Su trabajo es desacoplar formato y razonamiento. El skill decide el contenido; la plantilla fija la estructura.

### Archivo 4: `scripts/collect-commits.sh`

Este script genera el inventario de commits que el skill despues transforma.

```bash
#!/usr/bin/env bash
set -euo pipefail

start_ref="${1:?missing start ref}"
end_ref="${2:?missing end ref}"

git log --no-merges --pretty=format:'%h|%s' "${start_ref}..${end_ref}"
```

Hazlo ejecutable:

```bash
chmod +x scripts/collect-commits.sh
```

### Como se usa de punta a punta

1. Crea la estructura del paquete.
2. Escribe `SKILL.md`.
3. Agrega la referencia de categorias.
4. Agrega la plantilla.
5. Agrega el script y dale permisos.
6. Invoca el skill con un rango de release.

Ejemplo de invocacion:

```text
Use the release-notes-generator skill for v1.4.0..HEAD and draft the changelog plus a short stakeholder summary.
```

Resultado esperado:

1. Claude ejecuta `scripts/collect-commits.sh`.
2. Clasifica los commits con `references/commit-categories.md`.
3. Usa `assets/changelog-template.md` para renderizar la salida principal.
4. Produce una salida consistente y repetible para la release.

### Por que este ejemplo esta completo

Explica el paquete entero. No solo muestra carpetas abstractas: define el punto de entrada, la referencia, la plantilla, el script, la ubicacion de cada archivo y el flujo exacto de ejecucion.

<a id="skills-lista-calidad"></a>
## Lista De Calidad

Antes de dar por listo un skill, verificá estos puntos:

| Control | Por que importa |
|---|---|
| El trigger es especifico y realista | Evita subactivacion y superposicion accidental |
| El formato de salida esta explicitado | Reduce la ambiguedad en artefactos descendentes |
| Las herramientas estan acotadas | Limita el riesgo innecesario |
| Los recursos estan separados por rol | Mantiene legible el skill principal |
| Los prerrequisitos se validan temprano | Evita ejecucion parcial o fallida |
| Hay checkpoints donde el framing importa | Evita la rama descendente equivocada |
| Los ejemplos son completos cuando la salida puede confundirse | Mejora la correccion en el primer intento |

<a id="skills-buen-resultado"></a>
## Que Se Considera Un Buen Resultado

Un skill fuerte se lee como un contrato operativo. Le dice al modelo que tarea hacer, como decidir cuando hacerla, que recursos consultar, que puede salir mal y como debe verse el resultado final. Cuando el skill esta bien armado, el modelo gasta menos energia adivinando y mas energia ejecutando.
