# Ejemplos de Hooks

Este documento agrupa los hooks de ejemplo por comportamiento. La idea no es repetir la referencia, sino mostrar cómo encajan los patrones en la práctica.

## Índice

| Sección | Qué cubre |
| --- | --- |
| [Guardrails de seguridad](#guardrails-de-seguridad) | Bloqueo de comandos peligrosos, inyecciones y configuración manipulada |
| [Validación de salida](#validacion-de-salida) | Detección de secretos filtrados y salida poco confiable después de ejecutar herramientas |
| [Formateo y checks](#formateo-y-checks) | Formateo automático y validación liviana de tipos |
| [Ciclo de vida de la sesión](#ciclo-de-vida-de-la-sesion) | Arranque, resúmenes, renombrado y persistencia entre sesiones |
| [Ruteo y coaching de prompts](#ruteo-y-coaching-de-prompts) | Sugerencias, avisos de privacidad y guía en tiempo de prompt |
| [Notificaciones y feedback](#notificaciones-y-feedback) | Alertas de escritorio, TTS selectivo y recordatorios al final del turno |
| [Git y barreras pre-commit](#git-y-barreras-pre-commit) | Protección de commits antes de que salgan de la máquina |
| [Notas de plataforma](#notas-de-plataforma) | Diferencias entre Bash y PowerShell que importan en la práctica |

## Guardrails de Seguridad

Estos ejemplos buscan fallar rápido antes de que el modelo o el usuario puedan causar daño.

### Bloquear comandos peligrosos de shell

Usa un hook `PreToolUse` sobre `Bash` para detener comandos como borrados destructivos, force push a ramas protegidas o publicación de paquetes sin revisión. Esta es la forma correcta de hacer enforcement determinista.

La decisión importante es la rama por defecto. Un hook de guardrail debe permitir explícitamente el caso seguro y bloquear solo el conjunto estrecho de acciones de alto riesgo.

Matcher típico:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/dangerous-actions-blocker.sh"
          }
        ]
      }
    ]
  }
}
```

### Bloquear secretos en comandos

Un chequeo `PreToolUse` más estricto busca `password=`, `token=`, credenciales de AWS y formatos obvios de API keys dentro del propio comando. Esto detecta los leaks accidentales más comunes antes de que se ejecute la acción.

Úsalo cuando quieras una compuerta pequeña y rápida, en lugar de un escaneo más amplio del repositorio.

### Detectar intentos de prompt injection

Algunos hooks necesitan inspeccionar texto provisto por el usuario, contenido de archivos o URLs para detectar intentos de sobreescribir instrucciones. Los ejemplos de esta familia detectan:

- Frases de override como "ignore previous instructions"
- Lenguaje de jailbreak como "developer mode" o "do anything now"
- Delimiter injection como `</system>` o `[INST]`
- Payloads codificados como blobs base64
- Manipulación de terminal mediante secuencias ANSI
- Null bytes, sustitución anidada de comandos y otros trucos de bypass

El mejor caso de uso es proteger herramientas que manejan texto como `Bash`, `Write`, `Edit` y `WebFetch`.

### Escanear abuso de Unicode invisible

Los ataques basados en Unicode son otra clase de problema. Usan caracteres de ancho cero, overrides bidi, tag characters, codificaciones overlong o homoglyphs para hacer que contenido peligroso parezca inofensivo.

Este hook pertenece a la misma familia que la detección de prompt injection, pero se enfoca en el engaño visual más que en el semántico.

### Verificar integridad del repositorio

Otro patrón útil de `PreToolUse` es escanear archivos del repo que suelen esconder instrucciones o código de arranque: READMEs, guías de contribución, manifests de paquetes y directorios de configuración de IDE.

Esto es especialmente valioso en repositorios desconocidos. El hook puede advertir sobre comentarios HTML ocultos, scripts npm sospechosos, payloads parecidos a base64 o metacaracteres de shell embebidos en config.

### Proteger archivos y límites del sandbox

El ejemplo de file guard bloquea lecturas y escrituras sobre archivos protegidos como secretos, credenciales y llaves privadas. También rechaza trucos de path que intentan evadir la política mediante expansión de variables o sustitución de comandos.

La validación del sandbox es una preocupación separada. Verifica si el sandbox nativo está activo antes de ejecutar comandos bash en entornos estrictos. Tiene sentido cuando quieres una compuerta explícita antes de permitir operaciones sensibles.

### Verificar integridad de la configuración MCP

Los hooks de inicio de sesión son un buen lugar para validar configuraciones que pueden cambiar el comportamiento en silencio. El ejemplo de integridad MCP calcula el hash de la configuración global, lo compara con un baseline y avisa si el archivo cambió de forma inesperada.

También escanea flags riesgosos como comportamiento sin sandbox, versiones sin pinning, variables de entorno sospechosas y URLs externas embebidas en la config.

## Validación de Salida

Estos hooks corren después de que una herramienta ya produjo salida. No evitan la ejecución, pero sí pueden detectar problemas antes de confiar en el resultado.

### Detectar secretos filtrados en la salida

Usa `PostToolUse` para escanear la salida de comandos, archivos generados o texto del asistente en busca de API keys, claves privadas, URLs de base de datos con contraseña y otros patrones de credenciales. Este es el lugar correcto para frenar una exfiltración accidental a posteriori.

El hook debe advertir, no pasar silenciosamente. Si aparece un secreto en la salida, el desarrollador necesita una señal visible antes de copiar, commitear o compartir ese texto.

### Validación heurística de salida

El ejemplo de output validator busca rutas placeholder, marcadores TODO, dominios de ejemplo falsos, implementaciones incompletas y lenguaje con alta incertidumbre. Es intencionalmente liviano y debe tratarse como una heurística, no como un motor de verdad.

Úsalo para exponer problemas probables temprano y luego derivar a un flujo de revisión más profundo cuando haga falta.

## Formateo y Checks

Estos ejemplos mantienen el repositorio limpio con el menor roce posible.

### Formatear automáticamente después de editar

El hook de formateo corre después de `Edit` o `Write`, inspecciona la extensión del archivo cambiado y llama al formateador correspondiente. El caso más común es JavaScript, TypeScript, JSON, CSS, Markdown o HTML con Prettier, pero los ejemplos también incluyen formateo para Python, Go y Rust.

La característica clave es que el hook no bloquea y es silencioso. Debe mejorar el estado del repo sin convertirse en una fuente de interrupciones.

### Ejecutar un chequeo de TypeScript al guardar

Este hook solo se interesa por archivos `.ts` y `.tsx` y solo corre cuando existe un proyecto TypeScript. Es intencionalmente estrecho: úsalo para mostrar errores del compilador inmediatamente después de editar, no para reemplazar el pipeline completo de CI.

Cuando aparecen errores, el hook emite un `systemMessage` con la salida del compilador en lugar de bloquear la sesión.

### Equivalentes en PowerShell

Las versiones en PowerShell replican de cerca el comportamiento de Bash. Son útiles cuando el equipo trabaja en Windows y quiere la misma política sin obligar a instalar un shell Unix.

Mantén mínimas las diferencias de implementación. La política debe ser idéntica aunque cambie la sintaxis.

## Ciclo de Vida de la Sesión

Estos hooks preservan contexto, generan resúmenes y mantienen comprensibles las sesiones largas.

### Bootstrap de la sesión

Los hooks de setup son el lugar correcto para capturar condiciones de arranque como dependencias Node faltantes, la rama git actual o trabajo sin commitear. Son más útiles cuando el repositorio tiene expectativas de setup que conviene mostrar de inmediato.

El ejemplo aquí registra datos de arranque, avisa si falta `node_modules` e inyecta contexto de git cuando el workspace tiene cambios.

### Capturar un baseline de RTK

Si seguís el ahorro de tokens con RTK, un hook de baseline en `SessionStart` puede guardar el estado inicial. Un hook complementario al final de la sesión puede calcular el delta de esa sesión.

Este es un buen ejemplo de hooks en pareja: uno captura el estado inicial y el otro calcula la diferencia al final.

### Generar un resumen estructurado de sesión

El flujo de session summary es el ejemplo más grande del set. Lee el transcript de la sesión, agrega tool calls, uso de modelos, comportamiento de cache, cambios de archivos, stats de git diff, uso de features y ahorro RTK opcional, y luego imprime un resumen estructurado al cerrar la sesión.

También escribe un registro JSONL para análisis posterior. Eso lo convierte en algo más que una decoración de terminal: pasa a ser una capa real de observabilidad.

### Ajustar el resumen de forma interactiva

La herramienta de configuración asociada no es un hook en sí, pero forma parte del mismo patrón de ciclo de vida. Permite habilitar o deshabilitar secciones, cambiar el orden, previsualizar la salida, instalar los hooks e inspeccionar resúmenes recientes.

Ese es el patrón correcto para ergonomía operativa. El hook ejecuta; la CLI gobierna política y presentación.

### Renombrar sesiones automáticamente

El flujo de renombrado usa el contexto reciente de la conversación para generar un título breve. Si falla la generación con modelo, recurre a una versión sanitizada del primer mensaje del usuario.

El truco práctico acá es el control de salida: el hook escribe su estado en `/dev/tty` o `stderr` para no romper el parseo de JSON.

### Capturar un aprendizaje por sesión

El hook de journal de aprendizaje pide una sola reflexión cuando Claude termina. Siempre sale con éxito, así que nunca bloquea el cierre de la sesión, y escribe el resultado en un journal markdown local.

Eso lo vuelve útil como hook de formación de hábito más que como control de gobierno.

### Mostrar un recordatorio de privacidad

El hook de privacy warning es deliberadamente simple. Imprime un recordatorio al inicio de la sesión para que el usuario piense en retención de datos e implicaciones de entrenamiento, y luego se marca como mostrado para esa terminal.

Es un buen patrón para avisos de una sola vez que no deben volverse ruidosos.

## Ruteo y Coaching de Prompts

Estos ejemplos no bloquean trabajo. Lo encaminan.

### Sugerir el siguiente comando o agente

El hook de smart suggestion inspecciona el prompt del usuario e inyecta una sola sugerencia contextual. Está diseñado como un árbol de decisión priorizado con una sugerencia por prompt.

El valor práctico no es solo comodidad. También enseña el workflow local del equipo empujándolo hacia el comando o agente correcto en el momento de la intención.

### Avisos de privacidad y contexto en tiempo de prompt

También podés usar hooks de prompt para recordar al usuario políticas de datos, restricciones del proyecto o convenciones de sesión. Son útiles cuando el riesgo es conductual y no técnico.

La restricción importante es que sigan siendo livianos. Si el hook intenta hacer demasiado, deja de ser guía y pasa a ser fricción.

## Notificaciones y Feedback

### Notificaciones de escritorio

Los hooks de notificación encajan bien con alertas nativas del escritorio. El ejemplo de macOS elige un sonido según el contenido del mensaje y envía una notificación nativa para que el usuario no tenga que mirar la terminal.

Usalo cuando Claude suele quedarse esperando input y querés que la máquina te avise a vos, no al revés.

### Text-to-speech selectivo

El ejemplo de TTS selectivo es un filtro alrededor de un hook de audio más amplio. Solo habla cuando el mensaje coincide con un patrón elegido, como errores, mensajes de éxito o alertas de alta prioridad.

Esto es mejor que hablar cada notificación. La mayoría de los equipos solo quiere audio para los eventos que importan.

## Git y Barreras Pre-Commit

Estos hooks corren fuera de Claude Code, pero encajan en el mismo patrón de política.

### Bloquear secretos antes del commit

El scanner de secretos pre-commit inspecciona el contenido staged en busca de tokens, keys, passwords y cadenas con forma de credenciales. Bloquea el commit si algo parece inseguro y muestra pasos de remediación.

Esto pertenece al flujo porque el costo de un leak suele ser bastante mayor después de que el commit ya se compartió.

### Pedirle a Claude que juzgue el diff staged

El hook pre-commit con LLM-as-a-judge es opt-in y deliberadamente costoso. Envia el diff staged a Claude, pide un veredicto JSON y bloquea el commit si las notas o los issues caen por debajo del umbral.

Usalo cuando el equipo quiera una compuerta de revisión antes de que el código salga de la workstation y esté dispuesto a pagar ese costo.

## Notas de Plataforma

### Bash

Los hooks en Bash son los más fáciles de versionar y distribuir en macOS y Linux. Hacelos ejecutables, usá `jq` para parsear JSON y mantené la salida de shell estrictamente controlada.

### PowerShell

Los hooks en PowerShell son útiles en Windows, especialmente cuando el equipo trabaja con una base mixta. La política debería ser la misma aunque cambie la sintaxis.

### Dependencias prácticas

- `jq` para parseo de JSON
- `bc` para resúmenes numéricos
- `claude` para workflows de resumen o renombrado con modelo
- `npx`, `black`, `gofmt`, `rustfmt` u otros formateadores según corresponda

## Guía de Selección

| Si querés... | Usá este patrón |
| --- | --- |
| Frenar comandos riesgosos antes de que corran | `PreToolUse` |
| Revisar comandos antes del permiso del usuario | `PermissionRequest` |
| Formatear o validar después de editar | `PostToolUse` |
| Agregar contexto antes de que Claude razone | `UserPromptSubmit` |
| Resumir o limpiar al final | `SessionEnd` |
| Preservar estado entre sesiones | `SessionStart` o `Setup` |
| Notificar a una persona | `Notification` |

Los hooks más fuertes son los estrechos, predecibles y fáciles de explicar. Si un hook necesita un párrafo para justificar por qué existe, probablemente está haciendo demasiado.
