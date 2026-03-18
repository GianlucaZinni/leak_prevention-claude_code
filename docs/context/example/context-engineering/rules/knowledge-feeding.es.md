# Protocolo De Knowledge Feeding

La ingeniería de contexto no es un setup de una sola vez. Mejora cuando el proyecto aprende de sesiones reales y convierte ese aprendizaje en reglas durables.

## Cuándo Ejecutarlo

Ejecutá este protocolo al final de cualquier sesión que:

- completó un cambio significativo,
- descubrió un patrón nuevo que debería volverse estándar,
- expuso un error repetido que necesitó corrección,
- o tomó una decisión arquitectónica que conviene documentar.

Saltalo para trabajo trivial.

## Prompt

Usá este prompt al final de una sesión que lo amerite:

```text
Antes de cerrar esta sesión, hacé un knowledge feed:

1. Qué patrones establecimos que deberían convertirse en reglas permanentes?
2. Qué corregí o redirigí que debería ser una regla para evitar recurrencia?
3. Hubo decisiones arquitectónicas que CLAUDE.md debería registrar?
4. Hay algo en CLAUDE.md que esta sesión haya demostrado como incorrecto u obsoleto?

Respondé solo con items de alta señal. Usá el formato de knowledge feed de abajo.
No incluyas nada obvio o ya cubierto.
```

## Formato De Salida

```markdown
## Knowledge Feed - YYYY-MM-DD

### New Pattern
**What**: Una frase describiendo el patrón
**Why**: Por qué este enfoque es el correcto para este proyecto
**Rule to add**:
> Texto exacto para pegar en CLAUDE.md

### Anti-Pattern Found
**What happened**: Qué hizo mal Claude o qué hubo que corregir
**Why it's wrong here**: Razón específica del proyecto
**Rule to add**:
> Never: comportamiento específico a evitar y por qué

### Architecture Decision
**Decision**: Qué se decidió
**Rationale**: Por qué, especialmente si va contra la práctica común
**Rule to add**:
> Texto exacto para pegar en CLAUDE.md

### Stale Rule to Remove
**Rule**: Regla actual en CLAUDE.md
**Why remove**: Qué cambió y la vuelve obsoleta
```

## Flujo De Integración

Después de recibir el knowledge feed:

1. Revisar si el item es específico del proyecto.
2. Copiar las reglas relevantes a la sección correcta de `CLAUDE.md`.
3. Eliminar reglas obsoletas que la sesión haya expuesto.
4. Commit con un mensaje significativo.

## Filtro De Calidad

Antes de agregar una regla, verificá si es:

- específica del proyecto,
- accionable,
- ya está cubierta,
- y todavía va a ser cierta en seis meses.

