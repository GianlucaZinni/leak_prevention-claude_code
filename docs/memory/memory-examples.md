# Ejemplos de Memoria

<a id="index"></a>
## Índice
- [Instrucciones mínimas de proyecto](#minimal-project-instructions)
- [Reglas con alcance por ruta en la práctica](#path-scoped-rules-in-practice)
- [Memoria automática como cuaderno del proyecto](#auto-memory-as-a-project-notebook)
- [Cuándo elegir cada capa](#when-to-choose-each-layer)

<a id="minimal-project-instructions"></a>
## Instrucciones Mínimas de Proyecto

Este ejemplo muestra el patrón más pequeño y útil de `CLAUDE.md` para un repositorio que necesita guía duradera sin convertir el archivo en un volcado de políticas.

```text
repo/
├── CLAUDE.md
└── .claude/
    └── project.md
```

`CLAUDE.md` debe quedarse corto e importar el detalle.

```md
# Instrucciones del repositorio

@.claude/project.md

## Reglas principales

- Usa `pnpm`.
- Prefiere tests dirigidos antes de ejecutar toda la suite.
- Mantén breves las instrucciones de nivel repositorio.
```

`project.md` lleva los hechos duraderos del repositorio.

```md
# Detalles del proyecto

- Este servicio está basado en TypeScript.
- Los cambios en la API pública requieren una prueba de regresión.
- Los comandos de build son `pnpm build` y `pnpm test`.
```

<a id="path-scoped-rules-in-practice"></a>
## Reglas con Alcance por Ruta en la Práctica

Las reglas con alcance por ruta son la herramienta correcta cuando el equipo quiere comportamientos distintos para partes distintas del árbol.

```text
repo/
└── .claude/
    └── rules/
        ├── api.md
        ├── testing.md
        └── deployment.md
```

`api.md` se aplica solo a archivos de API.

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# Reglas de API

- Valida entradas antes de la lógica de negocio.
- Mantén los handlers explícitos y pequeños.
- Conserva formas de error estables.
```

`testing.md` puede cubrir una parte más amplia del código sin dejar de ser concreto.

```markdown
---
paths:
  - "src/**/*.{ts,tsx}"
  - "tests/**/*.test.ts"
---

# Reglas de testing

- Añade cobertura de regresión cuando cambie el comportamiento.
- Prefiere el test más pequeño que pruebe el problema.
- Ejecuta `pnpm test` antes de cerrar cambios.
```

<a id="auto-memory-as-a-project-notebook"></a>
## Memoria Automática como Cuaderno del Proyecto

La memoria automática funciona mejor como un cuaderno de observaciones duraderas, no como un segundo archivo de instrucciones.

```text
~/.claude/projects/acme-checkout/memory/
├── MEMORY.md
├── debugging.md
└── preferences.md
```

`MEMORY.md` debe resumir lo que existe.

```md
# MEMORY

## Temas

- debugging.md
- preferences.md

## Hechos estables

- Usa `pnpm test` para validación.
- La deriva del contrato de API es el riesgo de regresión más común.
```

`debugging.md` guarda modos de fallo recurrentes.

```md
# Notas de depuración

- Compara la validación de entrada con la forma de salida cuando fallen los tests de API.
- Revisa los valores por defecto del entorno cuando CI difiera de la ejecución local.
```

`preferences.md` guarda preferencias locales reutilizables.

```md
# Preferencias

- Prefiere logs concisos.
- Empieza con el test más pequeño que cubra el cambio.
```

<a id="when-to-choose-each-layer"></a>
## Cuándo Elegir Cada Capa

Usa `CLAUDE.md` cuando una regla deba verse siempre que Claude entre en el repositorio. Usa `.claude/rules/` cuando la regla solo pertenezca a ciertos archivos. Usa memoria automática cuando Claude deba recordar un hecho repetido sin convertirlo en política.

| Ejemplo | Mejor capa |
| --- | --- |
| "Usa `pnpm` en este repositorio" | `CLAUDE.md` |
| "Valida entradas bajo `src/api/`" | `.claude/rules/` |
| "CI en este repo necesita Redis local" | Memoria automática |
| "Para esta tarea solo toca `src/payments/`" | Contexto de sesión |

Cuando tengas dudas, inclínate por el alcance más estrecho. El alcance estrecho es más fácil de auditar, más fácil de evolucionar y menos probable que contamine trabajo ajeno.
