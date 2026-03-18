# Ejemplos de Agents

Este companion reúne patrones adicionales de subagents que son útiles en la práctica pero no hace falta integrar en la guía principal. Cada ejemplo está pensado para ser estrecho, reutilizable y fácil de razonar.

<a id="index"></a>
## Índice

- [Especialistas de solo lectura](#review-only-specialists)
- [Especialistas de ejecución](#execution-specialists)
- [Planificación y coordinación](#planning-and-coordination)
- [Flujos de seguridad](#security-workflows)
- [Operaciones e integración](#operations-and-integration)
- [Calidad y evaluación](#quality-and-evaluation)

<a id="review-only-specialists"></a>
## Especialistas de solo lectura

Estos agents inspeccionan el trabajo sin modificarlo. Son la mejor opción cuando quieres feedback de alta señal con riesgo operativo mínimo.

| Ejemplo | Propósito | Herramientas recomendadas | Notas |
| --- | --- | --- | --- |
| `code-reviewer` | Revisión general de código | `Read`, `Grep`, `Glob` | Mantenerlo de solo lectura y orientado a severidad |
| `architecture-reviewer` | Revisión estructural | `Read`, `Grep`, `Glob` | Enfocarlo en acoplamiento, cohesión y reversibilidad |
| `security-auditor` | Auditoría estilo OWASP | `Read`, `Grep`, `Glob` | Tratar los hallazgos como bloqueantes hasta demostrar lo contrario |

La decisión importante no es la etiqueta sino el contrato. Los revisores deberían devolver hallazgos, evidencia y recomendaciones concretas. No deberían derivar en implementación.

<a id="execution-specialists"></a>
## Especialistas de ejecución

Estos agents pueden cambiar archivos, pero aun así deberían trabajar a partir de un brief acotado.

| Ejemplo | Propósito | Herramientas recomendadas | Notas |
| --- | --- | --- | --- |
| `implementer` | Cambios mecánicos en archivos | `Write`, `Edit`, `Read`, `Bash` | Úsalo cuando el plan ya está decidido |
| `security-patcher` | Aplicar fixes de seguridad aprobados | `Write`, `Edit`, `Read` | Emparejarlo con una auditoría previa |
| `test-writer` | Crear o actualizar tests | `Write`, `Edit`, `Read`, `Bash` | Mantenerlo enfocado en comportamiento |

Estos workers deberían recibir una lista de archivos, un límite claro de alcance y un criterio concreto de éxito. Si la tarea todavía requiere decisiones nuevas de diseño, el worker es demasiado amplio.

<a id="planning-and-coordination"></a>
## Planificación y coordinación

Los agents de planificación son el espejo de los implementadores. Deberían producir estructura, secuencia y análisis de riesgo sin cambiar archivos.

| Ejemplo | Propósito | Herramientas recomendadas | Notas |
| --- | --- | --- | --- |
| `planner` | Descomponer trabajo en etapas | `Read`, `Grep`, `Glob` | Ideal antes de ejecuciones no triviales |
| `plan-challenger` | Revisión adversarial del plan | `Read`, `Grep`, `Glob` | Cuestiona supuestos y argumentos débiles |
| `planning-coordinator` | Combinar reportes de especialistas | `Read`, `Grep`, `Glob` | Útil cuando varias investigaciones deben converger |
| `adr-writer` | Capturar decisiones arquitectónicas | `Read`, `Grep`, `Glob` | Produce el registro de decisión, no la implementación |

Estos roles funcionan mejor cuando el formato de salida está fijado. Un plan que no puede escanearse rápido suele ser demasiado vago para ejecutarse con seguridad.

<a id="security-workflows"></a>
## Flujos de seguridad

Los agents de seguridad deberían fallar cerrado. Su trabajo es detectar riesgo temprano y mantener las acciones peligrosas bajo control.

El patrón más simple y útil es un flujo de dos pasos:

1. `security-auditor` lee el código y encuentra vulnerabilidades.
2. `security-patcher` aplica solo los fixes aprobados.

Separar detección de cambio preserva la auditabilidad. Cuando ambos trabajos colapsan en un único worker, la revisión suele debilitarse.

En entornos más estrictos, un agent de seguridad también puede trabajar con hooks que validen comandos `Bash` o bloqueen usos inseguros de herramientas. Eso es especialmente útil alrededor de acceso a bases de datos, comandos de despliegue y manejo de secretos.

<a id="operations-and-integration"></a>
## Operaciones e integración

Los agents operativos son útiles cuando el trabajo cruza sistemas, logs o configuración de entorno.

| Ejemplo | Propósito | Herramientas recomendadas | Notas |
| --- | --- | --- | --- |
| `devops-sre` | Diagnóstico de incidentes | `Read`, `Grep`, `Glob`, `Bash` | Dale límites explícitos de rollback y aprobación |
| `integration-reviewer` | Revisión de integraciones en runtime | `Read`, `Grep`, `Glob` | Valida parámetros de conexión y completitud de variables de entorno |

Estos workers son más fuertes cuando reciben detalles concretos del entorno y una frontera clara entre diagnóstico y remediación.

<a id="quality-and-evaluation"></a>
## Calidad y evaluación

Los agents de evaluación convierten calidad subjetiva en un proceso repetible. Eso los vuelve valiosos cuando el mismo tipo de salida aparece con suficiente frecuencia como para justificar una puntuación, un veredicto o un reporte recurrente.

| Ejemplo | Propósito | Herramientas recomendadas | Notas |
| --- | --- | --- | --- |
| `output-evaluator` | Puntuar salidas antes de actuar | `Read`, `Grep`, `Glob` | Útil como gate antes del commit o release |
| `analytics-agent` | Generación SQL con métricas | `Read`, `Bash` | Funciona bien con hooks y revisión mensual |

### Analytics Agent con evaluación

Este patrón es especialmente útil cuando la misma salida especializada necesita medirse a lo largo del tiempo. Empaqueta juntos el agent, el hook, el archivo de settings, el script de métricas y la plantilla de reporte. Eso hace que el agent sea reutilizable y observable al mismo tiempo.

La guía principal incluye una versión completa de extremo a extremo de este patrón. Si construyes un flujo similar para otro dominio, conserva la misma forma: un agent, un hook, un archivo de settings, un script de análisis y una plantilla de reporte.

### Pipeline multietapa

Cuando una tarea puede dividirse en etapas con contratos explícitos de entrada y salida, usa varios agents estrechos en lugar de uno grande. Un pipeline sano puede parsear datos crudos, detectar anomalías, clasificar severidad y luego producir un reporte legible para humanos. La clave es que cada etapa haga un solo trabajo bien y emita un artefacto definido.
