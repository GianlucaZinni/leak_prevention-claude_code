---
title: "Ejemplos de Ingeniería de Contexto"
description: "Plantillas y scripts operativos que acompañan el flujo de ingeniería de contexto"
tags: [contexto, ejemplos, plantillas, scripts, ci]
---

# Ejemplos de Ingeniería de Contexto

Este documento complementario explica los artefactos operativos que usa el toolkit de ingeniería de contexto. La guía principal describe el sistema. Esta página se enfoca en los archivos de soporte, cómo encajan entre sí y de qué se encarga cada uno.

<a id="index"></a>
## Índice

- [Visión General Del Bundle](#bundle-overview)
- [Plantilla De Perfil](#profile-template)
- [Plantilla Skeleton](#skeleton-template)
- [Assembler](#assembler)
- [Preguntas De Evaluación](#evaluation-questions)
- [Canary Check](#canary-check)
- [Detección De Drift](#drift-detection)
- [Calculador De Presupuesto](#budget-calculator)
- [Knowledge Feeding](#knowledge-feeding)
- [Retrospectiva De Sesión](#session-retrospective)

<a id="bundle-overview"></a>
## Visión General Del Bundle

El bundle de ejemplo es un toolkit pequeño, no un único archivo. Está diseñado para soportar un flujo repetible:

1. describir el perfil del desarrollador,
2. definir la estructura inicial de `CLAUDE.md`,
3. ensamblar el archivo final,
4. validar el resultado,
5. y devolver al sistema lo aprendido en sesiones reales.

El valor de este bundle es que hace explícito el mantenimiento del contexto. En lugar de tratar `CLAUDE.md` como un documento estático, lo trata como salida generada con controles alrededor.

<a id="profile-template"></a>
## Plantilla De Perfil

La plantilla de perfil define la forma de la entrada específica de cada desarrollador. Registra rol, herramientas, estilo, módulos incluidos, módulos excluidos y reglas personales opcionales.

Usala cuando:

- distintos desarrolladores necesiten distinto contexto por defecto,
- el mismo proyecto use stacks o modos de trabajo diferentes,
- o quieras mantener preferencias personales fuera de las reglas compartidas.

La decisión importante es que el perfil sea declarativo. No arma el contexto por sí solo. Le dice al assembler qué incluir.

<a id="skeleton-template"></a>
## Plantilla Skeleton

La plantilla skeleton es la estructura inicial de un archivo de contexto de proyecto. Le da a Claude un esquema consistente para overview del proyecto, arquitectura, estándares de código, flujo de trabajo, testing, despliegue y anti-patrones.

Usala cuando:

- inicies un nuevo archivo de contexto,
- reescribas un archivo largo y ruidoso,
- o quieras alinear a un equipo con un estándar de configuración nuevo.

El valor de la skeleton no está en los placeholders en sí. Está en el orden forzado. Las mismas secciones deben aparecer en el mismo orden para que el contexto sea fácil de escanear y auditar.

<a id="assembler"></a>
## Assembler

El assembler transforma un perfil más un conjunto de módulos en un `CLAUDE.md` final. Está diseñado para ser explícito sobre las entradas y la salida, de modo que el archivo generado pueda regenerarse y compararse más tarde.

Usalo cuando:

- quieras una sola fuente de verdad para el contexto generado,
- quieras verificar si un archivo versionado todavía coincide con su perfil,
- o quieras mantener el contexto del proyecto reproducible entre compañeros.

El assembler debe considerarse parte del sistema de documentación. Si se vuelve demasiado ingenioso, pierde confianza. El ejemplo lo mantiene simple para que la salida siga siendo auditable.

<a id="evaluation-questions"></a>
## Preguntas De Evaluación

El archivo de preguntas de evaluación es una herramienta de auditoría manual. Ayuda a decidir si la configuración actual está completa, es específica, sigue siendo compacta y todavía coincide con el proyecto.

Usalo cuando:

- el archivo crece,
- el proyecto cambia de forma,
- o Claude empieza a comportarse de manera inconsistente.

Es útil porque separa calidad de contenido de detalles de implementación. Podés correr la auditoría antes de decidir si el problema es que faltan reglas, que son vagas o que hay demasiado ruido.

<a id="canary-check"></a>
## Canary Check

El script de canary es una prueba estructural de regresión para el contexto. Verifica que el archivo exista, que los imports resuelvan, que el archivo no esté obviamente inflado y que la configuración todavía parezca coherente.

Usalo cuando:

- se edita un contexto de proyecto,
- se agrega un módulo nuevo,
- o querés una barrera automática y barata antes de que el problema llegue a uso real.

Los canaries deben seguir siendo simples. Su trabajo no es entender el proyecto completo. Su trabajo es detectar roturas temprano y barato.

<a id="drift-detection"></a>
## Detección De Drift

El workflow de drift extiende la idea del canary a CI. Corre en un schedule, revisa la configuración actual y expone contexto obsoleto cuando la salida generada ya no coincide con el estado versionado.

Usalo cuando:

- el proyecto cambia seguido,
- varias personas pueden editar el set de contexto,
- o el archivo generado es lo bastante importante como para que la obsolescencia sea un riesgo real.

El beneficio práctico es la responsabilidad. El drift no desaparece en silencio. Se detecta, se reporta y queda con una ruta clara de seguimiento.

<a id="budget-calculator"></a>
## Calculador De Presupuesto

El calculador de presupuesto estima el costo del contexto siempre activo. No es contabilidad exacta de tokens. Es una herramienta direccional que te dice si la configuración sigue siendo liviana, saludable, pesada o saturada.

Usalo cuando:

- el archivo raíz empieza a crecer,
- se agregan más módulos,
- o necesitás una señal rápida antes de aprobar un cambio más grande.

El calculador es útil porque vuelve visible el costo del contexto. Si el presupuesto sube, eso suele indicar que algunas reglas deberían moverse a un módulo por ruta, a un skill o a un documento de workflow separado.

<a id="knowledge-feeding"></a>
## Knowledge Feeding

La regla de knowledge feeding describe cómo capturar aprendizaje de una sesión y convertirlo en conocimiento durable del proyecto.

Usala cuando:

- se corrigió un error repetido,
- un patrón nuevo resultó útil,
- o una decisión arquitectónica debería documentarse antes de olvidarla.

La salida debe tener alta señal solamente. Si cada sesión produce una lista larga, el sistema agrega ruido en lugar de claridad.

<a id="session-retrospective"></a>
## Retrospectiva De Sesión

El prompt de retrospectiva es la forma más simple de mantener el contexto actualizado. Pregunta qué patrones aparecieron, qué correcciones fueron necesarias, qué conviene replicar y qué ya quedó obsoleto.

Usalo cuando:

- la sesión cambió la forma de trabajar,
- un defecto reveló una regla faltante,
- o el equipo quiere un hábito que mejore el contexto de manera sostenida.

La mejor salida de retrospectiva es lo bastante concreta como para pegarse en la sección correcta con mínima edición.
