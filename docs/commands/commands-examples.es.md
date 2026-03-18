# Ejemplos de Commands

Este companion reúne patrones de commands más acotados que complementan la guía principal. La guía principal contiene un workbench completo de extremo a extremo. Este documento muestra formas adicionales de commands que puedes adaptar cuando tu repositorio necesita workflows más estrechos.

<a id="index"></a>
## Índice

- [Commands de review y auditoría](#review-and-audit-commands)
- [Commands de planificación y ejecución](#planning-and-execution-commands)
- [Commands de release y entrega](#release-and-delivery-commands)
- [Commands de aprendizaje](#learning-commands)
- [Commands de mantenimiento del repositorio](#repository-maintenance-commands)

<a id="review-and-audit-commands"></a>
## Commands de review y auditoría

Los commands de review son la categoría de mayor valor porque comprimen una rúbrica repetitiva de evaluación en una interfaz estable.

Patrones típicos:

- revisión de pull request con hallazgos estructurados
- revisión de plan antes de comenzar la implementación
- auditoría de seguridad del repositorio y su configuración
- validación dirigida después de un cambio

Los mejores commands de review definen severidad desde el inicio y fuerzan una forma de salida fácil de escanear durante code review o handoff operativo.

<a id="planning-and-execution-commands"></a>
## Commands de planificación y ejecución

Los commands de planificación son útiles cuando el repositorio usa un workflow formal de planificar antes de construir. Normalmente parsean un plan existente, escalonan la ejecución en fases y definen checkpoints de calidad y deriva.

Subpatrones útiles:

- crear un plan a partir de un pedido
- validar un plan antes de ejecutarlo
- ejecutar un plan validado en un worktree
- diagnosticar desvío entre plan e implementación

Estos commands deberían ser explícitos sobre sus condiciones de parada. Un command de planificación que nunca dice cuándo termina suele convertirse en un prompt de orquestación sin límite.

<a id="release-and-delivery-commands"></a>
## Commands de release y entrega

Los commands de release traducen historial Git y datos de pull requests en artefactos que un equipo realmente necesita para publicar software.

Salidas comunes:

- secciones de changelog
- cuerpos de pull request de release
- anuncios de release orientados a usuarios
- alertas de migración y notas de rollout

La decisión de diseño clave es separar cambios orientados al usuario del trabajo interno de ingeniería. Los commands de release se vuelven mucho más útiles cuando hacen esa transformación de manera consistente.

<a id="learning-commands"></a>
## Commands de aprendizaje

No todos los repositorios necesitan commands de enseñanza, pero son valiosos en equipos que usan Claude Code para onboarding, pair-learning o flujos recurrentes de explicación.

Los buenos commands de aprendizaje suelen hacer una de estas tres cosas:

- explicar un concepto a partir del repositorio actual
- comparar alternativas con trade-offs
- generar quizzes o checkpoints cortos para verificar comprensión

Estos commands deberían optimizar claridad en lugar de amplitud de ejecución. Funcionan mejor cuando cargan un conjunto reducido de archivos y devuelven una explicación estructurada.

<a id="repository-maintenance-commands"></a>
## Commands de mantenimiento del repositorio

Los commands de mantenimiento cubren salud del repositorio, higiene local y automatización segura alrededor de Git o del estado del workspace.

Ejemplos comunes:

- creación y limpieza de worktrees
- resúmenes de puesta al día del repositorio
- chequeos de sandbox o permisos
- validación incremental después de cambios locales

Estos commands deberían ser conservadores. Los commands de mantenimiento suelen estar más cerca de acciones destructivas, así que se benefician de allowlists más estrictas y de un paso claro de confirmación cuando el workflow cruza un límite de confianza.
