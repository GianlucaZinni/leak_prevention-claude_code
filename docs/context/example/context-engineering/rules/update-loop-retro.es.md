# Plantilla De Retrospectiva De Sesión

Un prompt estructurado para correr al final de una sesión de Claude Code. El objetivo es capturar conocimiento mientras sigue fresco y convertirlo en reglas durables.

## Prompt

```text
Sesión completa. Antes de cerrar, hacé una retrospectiva rápida:

1. Qué patrones establecimos que deberían ser reglas permanentes en CLAUDE.md?
2. Qué corregí que Claude hizo mal? Debería existir una regla para prevenirlo?
3. Qué funcionó bien y deberíamos replicar en sesiones futuras?
4. Hubo decisiones arquitectónicas que CLAUDE.md debería registrar?
5. Hay algo actualmente en CLAUDE.md que esta sesión haya demostrado como incorrecto u obsoleto?

Devolvé un knowledge feed - 3 a 5 bullets máximo, items de alta señal solamente.
No incluyas nada obvio, genérico o ya presente en CLAUDE.md.
Formateá cada item como una regla accionable lista para copiar.
```

## Cuándo Ejecutarlo

| Disparador | Ejecutar retro? |
|---|---|
| Feature o refactor grande completado | Sí |
| Sesión de debugging que expuso una brecha sistémica | Sí |
| Decisión arquitectónica tomada | Sí |
| Onboarding que reveló contexto faltante | Sí |
| Mensualmente, aunque no haya pasado nada grande | Sí |
| Sesión trivial | No |

## Cómo Debería Verse La Salida

La salida debería ser concreta y lo bastante específica como para pegarse en la sección correcta con mínima edición. Los buenos items son específicos del proyecto, accionables y fáciles de verificar después.

## Después De La Retro

1. Revisar la salida.
2. Agregar las reglas útiles a `CLAUDE.md`.
3. Eliminar lo obsoleto.
4. Commit con un mensaje trazable.

