# Patrones De Skills: Ejemplos

Este documento reune skills representativos del directorio y explica el patron de diseno que usa cada uno. El objetivo no es catalogar archivo por archivo. El objetivo es mostrar los movimientos arquitectonicos que vuelven confiables a estos skills: etapas, plantillas, material de referencia, ayudantes deterministas y checkpoints claros.

## Indice

| Ejemplo | Patron | Que demuestra |
|---|---|---|
| Pipeline de preparacion de charlas | Orquestador multietapa | Handoffs entre etapas, checkpoints humanos y subtareas paralelizables |
| Generador de notas de release | Clasificacion + salidas con plantilla | Convertir datos tecnicos de cambios en artefactos para distintas audiencias |
| Generador de landing pages | Extraccion de contenido + ensamblado estatico | Plantillas de secciones, snippets reutilizables y salida lista para deploy |
| Flujo de triage de PRs | Proceso de revision por fases | Analisis inicial, comentarios validados y creacion opcional de worktrees |
| Refinado de voz | Normalizacion de entrada | Comprimir dictado ruidoso en un prompt estructurado |
| Analizador de design patterns | Deteccion + recomendaciones segun stack | Datos de referencia, reglas de scoring y alternativas nativas |

## 1. Pipeline De Preparacion De Charlas

Este es un orquestador por etapas. Toma material bruto como un articulo, transcript o notas y lo convierte en un paquete completo para una charla. La idea clave es que cada etapa tiene una responsabilidad distinta: extraccion, investigacion, catalogo de conceptos, posicionamiento, guion y soporte de revision.

El paquete funciona porque las etapas estan ordenadas y los handoffs son explicitos. Una etapa escribe un resumen estructurado, la siguiente lo enriquece con contexto verificado, y las posteriores usan esas salidas en lugar de releer la fuente cruda. Antes de la etapa de guion aparece un checkpoint humano, porque la decision de framing no debe adivinarse.

El aprendizaje reutilizable es simple: usar artefactos intermedios como contratos. Una vez que una etapa produjo un resumen, una tabla de conceptos o una eleccion de titulo, las etapas posteriores deberian leer esos archivos en vez de reconstruir la intencion desde la conversacion original.

## 2. Generador De Notas De Release

Este skill es un pipeline de transformacion. Lee commits y contexto de release, clasifica los cambios, traduce lenguaje tecnico a lenguaje de producto y emite multiples salidas segun la audiencia. La misma informacion se presenta de formas distintas para developers, reviewers y stakeholders.

La estructura importa mas que la prosa. Una capa de referencia define como mapear frases tecnicas a valor de usuario. Los assets de plantilla preservan el tono y la forma de cada canal. El skill principal orquesta el proceso y mantiene la salida consistente.

El patron util aqui es "una sola fuente de verdad, muchas representaciones". Los datos del release se analizan una vez, pero pueden renderizarse como una seccion de changelog, un cuerpo de PR o un mensaje corto de Slack sin repetir la clasificacion.

## 3. Generador De Landing Pages

Este skill es un extractor de contenido mas un ensamblador de sitios estaticos. Recorre la documentacion del repositorio, extrae la identidad del proyecto, el conjunto de features, los pasos de instalacion y las FAQ, y luego arma una landing deployable. Es un buen ejemplo de un skill que depende mucho de plantillas y fragmentos de UI reutilizables.

El diseno es modular. Los snippets de seccion definen la estructura de la pagina. Los estilos compartidos definen la apariencia. La logica de busqueda y el workflow de deployment viven junto con el contenido para que el resultado no sea solo un volcado de texto sino un sitio utilizable.

La leccion es que la calidad de salida mejora cuando el skill conoce el medio objetivo. Una landing page no es un README con estilos. Es un artefacto distinto con su propia jerarquia de informacion y su propio modelo de interaccion.

## 4. Flujo De Triage De PRs

Este es un sistema de revision por fases. Comienza con una auditoria del backlog, puede escalar a una revision profunda con agentes paralelos, exige validacion antes de postear comentarios y puede crear worktrees para inspeccion local. El flujo esta deliberadamente acotado porque la salida de una revision afecta a personas y pull requests reales.

La parte interesante es el diseno por fases. Primero audita, luego inspecciona a fondo solo los PR seleccionados, valida los comentarios antes de publicarlos y solo despues hace la configuracion opcional de worktrees. Cada fase tiene un perfil de riesgo distinto, por eso el skill las expone como decisiones separadas.

La leccion reutilizable es que los skills de revision deben separar analisis de accion. Una tabla de resumen no es lo mismo que un comentario publicado, y un comentario propuesto no es lo mismo que una revision ya enviada.

## 5. Refinado De Voz

Este skill normaliza dictado en flujo de conciencia en un prompt compacto. Elimina muletillas, deduplica ideas repetidas, extrae la solicitud real y emite un brief estructurado con contexto, objetivo, restricciones y expectativas de salida.

La huella de recursos es intencionalmente pequena. El skill es basicamente una transformacion de prompt con un formato objetivo claro, por lo que no necesita una gran biblioteca de referencia ni muchos scripts. Se beneficia de un esquema de salida estricto porque el valor esta en reducir ruido, no en generar contenido nuevo.

La leccion es que la compresion puede ser una feature. Un buen skill de normalizacion conserva la intencion y elimina el desvio verbal. Eso hace que el modelo aguas abajo sea mas rapido y mas preciso.

## 6. Analizador De Design Patterns

Este skill combina datos de referencia, reglas de scoring y recomendaciones segun el stack. Detecta patrones clasicos, evalua la calidad de su implementacion y sugiere alternativas nativas cuando el stack objetivo ya ofrece un idiom mejor.

La estructura es por capas. Un indice legible por maquina define el universo de patrones. Las firmas de deteccion codifican las senales. Un checklist define como puntuar correccion, testabilidad, responsabilidad, extensibilidad y documentacion. Luego las reglas de stack adaptan la recomendacion al framework real en uso.

La leccion clave es que los skills de referencia mejoran cuando no son solo descriptivos. Tambien deberian codificar logica de decision. Aqui el skill no se limita a decir "esto parece Observer". Explica si la implementacion es buena, si el stack tiene un reemplazo nativo mejor y que hacer despues.

## Lo Que Tienen En Comun

| Rasgo comun | Por que importa |
|---|---|
| Trigger claro | El skill se activa cuando el usuario realmente lo necesita |
| Contrato de salida explicito | Las etapas siguientes saben que esperar |
| Separacion de responsabilidades | El skill principal sigue siendo legible |
| Recursos de apoyo | Las reglas profundas y las plantillas no ensucian el entrypoint |
| Validacion o checkpoints | Las transiciones sensibles se controlan |
| Salidas segun audiencia | Una misma fuente puede renderizarse para consumidores distintos |

## Conclusion Practica

Si vas a disenar un skill nuevo, empezá por decidir cual de estos patrones estas construyendo. Si la tarea tiene varias etapas, construi un coordinador. Si la tarea es repetitiva, mové la mecanica a scripts. Si la tarea es principalmente conocimiento, mové la profundidad a `references/`. Si la tarea produce artefactos estructurados, inverti en plantillas. Los mejores skills de este directorio no intentan ser genericos. Se mantienen estrechos, explicitos y componibles.

