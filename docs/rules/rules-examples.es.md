# Ejemplos de Rules

Este companion muestra patrones más pequeños de rules que acompañan a la guía principal. La guía principal contiene un pack completo. Este documento resalta formas enfocadas que puedes mezclar dentro de un repositorio sin adoptar todo el ejemplo tal como está.

<a id="index"></a>
## Índice

- [Contrato de invariantes de sesión](#session-invariant-contract)
- [Overlay de review de arquitectura](#architecture-review-overlay)
- [Overlay de calidad de código](#code-quality-overlay)
- [Overlay de performance](#performance-overlay)
- [Overlay de review de tests](#test-review-overlay)

<a id="session-invariant-contract"></a>
## Contrato de invariantes de sesión

Un archivo de invariantes de sesión es el lugar correcto para restricciones que nunca deberían romperse. Debería seguir siendo lo bastante corto como para leerse al inicio y lo bastante explícito como para sobrevivir a la compresión del contexto.

Contenidos típicos:

- límites de seguridad de datos
- restricciones de proceso como disciplina de commits
- límites de alcance de tarea
- umbrales medibles de calidad

Si una rule tiene excepciones todos los días, no pertenece a esta capa.

<a id="architecture-review-overlay"></a>
## Overlay de review de arquitectura

Un overlay de arquitectura debería ayudar a Claude a inspeccionar estructura en lugar de repetir estilo de código.

Preguntas útiles para este overlay:

- ¿Las responsabilidades están separadas en límites limpios?
- ¿La propiedad de los datos es explícita?
- ¿Las interfaces son estrechas y estables?
- ¿Dónde están los puntos de fallo bajo más carga?

Este overlay funciona mejor sobre planes, ADRs, refactors de subsistemas y cambios transversales.

<a id="code-quality-overlay"></a>
## Overlay de calidad de código

Un overlay de calidad de código se enfoca en mantenibilidad más que en corrección bruta.

Checks de alto valor:

- lógica duplicada
- manejo débil o silencioso de errores
- nombres o ubicación de módulos inconsistentes
- sobre-ingeniería e infra-ingeniería

Este overlay es especialmente efectivo cuando el repositorio ya tiene automatización de estilo, porque así la rule puede enfocarse en estructura y no en formato.

<a id="performance-overlay"></a>
## Overlay de performance

Las rules de performance deberían ayudar a Claude a hacerse las preguntas correctas antes de empezar a optimizar.

Los checks más útiles suelen ser:

- forma de las queries y patrones N+1
- granularidad de carga de datos
- trabajo innecesario en hot paths
- ubicación de fronteras de caché

Los overlays de performance son más valiosos cuando el repositorio ya sabe qué rutas son user-facing o sensibles a latencia.

<a id="test-review-overlay"></a>
## Overlay de review de tests

Las rules de tests deberían mantener el foco en comportamiento, gaps de cobertura y modos de fallo.

Un buen overlay de tests pregunta:

- qué comportamiento público sigue sin cobertura
- si los failure paths están cubiertos
- si los edge cases son explícitos
- si los tests son independientes y estables

Este overlay se vuelve más fuerte cuando el contrato del repositorio ya define qué tipos de cambios requieren testing de regresión o integración.
