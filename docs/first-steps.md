## 1.2 Comandos esenciales

| Comando | Acción | Cuándo utilizar |
|---------|--------|-------------|
| `/help` | Mostrar todos los comandos | Cuando estás perdido |
| `/clear` | Conversación clara | Empezar de nuevo |
| `/compact` | Resumir contexto | Se está acabando el contexto |
| `/status` | Mostrar información de la sesión | Verificar el uso del contexto |
| `/exit` o `Ctrl+D` | Salir del código Claude | Finalizar el trabajo |
| `/plan` | Ingrese al modo de plan | Exploración segura |
| `/rewind` | Deshacer cambios | Cometió un error |
| `/voice` | Alternar entrada de voz | Habla en lugar de escribir |

### Acciones rápidas y atajos

| Atajo | Acción | Ejemplo |
|----------|--------|---------|
| `!command` | Ejecutar un comando Shell directamente | `!git status`, `!npm test` |
| `@file` | Hacer referencia a un archivo específico | `@src/app.py`, `@README.md` |
| `Ctrl+C` | Cancelar operación actual | Detener el análisis de larga duración |
| `Ctrl+R` | Historial de comandos de búsqueda | Buscar indicaciones anteriores |
| `Esc` | Detener a Claude en mitad de la acción | Interrumpir el funcionamiento actual |

#### Comandos de Shell con `!`

Ejecutar comandos inmediatamente sin pedirle a Claude que lo haga:

```bash
# Verificaciones de estado rápidas
!git status
!npm run test
!poetry run pytest
!docker ps

# Ver registros
!tail -f logs/app.log
!cat package.json

# Búsquedas rápidas
!grep -r "TODO" src/
!find . -name "*.test.py"
```

**Ejemplo de flujo de trabajo**:
```
Vos: !git status
Salida: Muestra 5 archivos modificados

Vos: Crear una confirmación con estos cambios, siguiendo las confirmaciones convencionales.
Claude: [Analiza archivos, sugiere mensaje de confirmación]
```

#### Referencias de archivos con `@`

Hacer referencia a archivos específicos en las indicaciones para operaciones específicas:

```bash
# Archivo único
Revisar @src/auth/login.py para problemas de seguridad

# Múltiples archivos
Refactorizar @src/utils/validation.py y @src/utils/helpers.pý para eliminar la duplicación

# Con comodines (en algunos contextos se le podría pasar una serie de archivos)
Analizar todos los archivos de prueba @src/**/*.test.py

# Las rutas relativas también funcionan
Consultar @./CLAUDE.md para conocer las convenciones del proyecto.
```

**Por qué utilizar `@`**:
- **Precisión**: Apuntar a archivos exactos en lugar de dejar que Claude busque
- **Velocidad**: Omitir la fase de descubrimiento de archivos
- **Contexto**: Le indica a Claude que lea estos archivos a pedido mediante herramientas
- **Claridad**: Hace que tu intención sea explícita

**Ejemplo**:
```
# Sin @
Vos: arreglar el error de autenticación
Claude: ¿Qué archivo contiene la lógica de autenticación? [Pierde el tiempo buscando]

# Con @
Vos: corrijir el error de autenticación en @src/auth/middleware.py
Claude: [Lee el archivo a pedido y propone una solución]
```

#### Trabajar con imágenes y capturas de pantalla

Claude Code admite **entrada directa de imágenes** para análisis visual, implementación de maquetas y comentarios sobre el diseño.

**Cómo utilizar imágenes**:

1. **Pegar directamente en la terminal** (macOS/Linux/Windows con terminal): 
- Copiar captura de pantalla o imagen al portapapeles (`Cmd+Shift+4` en macOS, `Win+Shift+S` en Windows) 
- En la sesión de Claude Code, pegar con `Cmd+V` / `Ctrl+V` 
- Claude recibe la imagen y puede analizarla.

1. **Arrastrar y soltar** (algunos terminales): 
- Arrastre el archivo de imagen a la ventana de terminal 
- Claude carga y procesa la imagen.

1. **Referencia con ruta**: 
```bash
Analizar esta maqueta: /path/to/design.png 
```

**Casos de uso comunes**:

```bash
# Implementar la interfaz de usuario desde la maqueta
Vos: [Pegar captura de pantalla del diseño]
Implementar esta pantalla de inicio de sesión en React con Tailwind CSS

# Depurar problemas visuales
Vos: [Pegar captura de pantalla del diseño roto]
El botón está desalineado. Arreglar el CSS.

# Analizar diagramas
Vos: [Pegar diagrama de arquitectura]
Explicar la arquitectura de este sistema e identificar posibles cuellos de botella.

# Código en formato diagrama / imagen
Vos: [Pegar foto de un algoritmo]
Convertir este algoritmo a código Python

# Auditoría de accesibilidad
Vos: [Pegar captura de pantalla de la interfaz de usuario]
Revisar esta interfaz para problemas de cumplimiento de WCAG 2.1
```

**Formatos admitidos**: PNG, JPG, JPEG, WebP, GIF (estático)

**Mejores prácticas**:
- **Alto contraste**: asegurarse de que el texto/los diagramas sean claramente visibles
- **Recortar de forma relevante**: eliminar elementos innecesarios de la interfaz de usuario para un análisis centrado
- **Anotar cuando sea necesario**: marcar con un círculo o resalta áreas específicas en las que deseas que Claude se centre
- **Combinar con texto**: "Centrarse en la sección del encabezado" proporciona contexto adicional

**Ejemplo de flujo de trabajo**:
```bash
Vos: [Pegar captura de pantalla del mensaje de error en la consola del navegador]
Este error aparece cuando los usuarios hacen clic en el botón Enviar. Depurálo.

Claude: Puedo ver el error "TypeError: No se puede leer la propiedad 'valor' de nulo".
Esto sugiere que la referencia del campo del formulario es incorrecta. Déjame comprobar el código de manejo de tu formulario...
[Lee archivos relevantes y propone una solución]
```

**Limitaciones**:
- Las imágenes consumen tokens de contexto significativos (equivalentes a ~1000-2000 palabras de texto)
- Utilizar `/status` para monitorear el uso del contexto después de pegar imágenes
- Considerar describir diagramas complejos textualmente si el contexto es limitado.
- Es posible que algunos terminales no admitan el pegado de imágenes del portapapeles (posibildiad: guardar y hacer referencia a la ruta del archivo)

> **💡 Consejo**: Tomar capturas de pantalla de mensajes de error, maquetas de diseño y documentación en lugar de describirlos textualmente. La información visual suele ser más rápida y precisa que las descripciones escritas.

##### Optimización de imagen para Claude

Comprender el procesamiento de imágenes de Claude ayuda a optimizar la velocidad y la precisión.

**Pautas de resolución**:

| Gama | Efecto |
|-------|--------|
| **< 200px** | Pérdida de precisión, texto ilegible |
| **200-1000px** | Punto ideal para la mayoría de los wireframes |
| **1000-1568px** | Equilibrio óptimo entre calidad y tokens |
| **1568-8000px** | Reducción automática de escala (desperdicia tiempo de carga) |
| **> 8000px** | Rechazado por API |

**Cálculo de tokens**: `(ancho × alto) / 750 ≈ tokens consumidos`

| Tamaño de imagen | Fichas aproximadas |
|------------|-------------------|
| 200×200 | ~54 fichas |
| 500×500 | ~334 fichas |
| 1000×1000 | ~1.334 fichas |
| 1568×1568 | ~3279 fichas |

**Recomendaciones de formato**:

| Formato | Usar cuando |
|--------|----------|
| **PNG** | Estructuras alámbricas, diagramas, texto, líneas nítidas |
| **WebP** | Capturas de pantalla generales, buena compresión |
| **JPEG** | Sólo fotos: los artefactos de compresión dañan la detección de líneas |
| **GIF** | Evitar (solo estática, mala calidad) |

**Lista de verificación de optimización**:
- [ ] Recortar solo en el área relevante
- [ ] Cambiar el tamaño a 1000-1200 px si es más grande
- [ ] Utilice PNG para estructuras/diagramas
- [ ] Utilizar `/status` después de pegar, para monitorear el uso del contexto
- [ ] Considerear la descripción del texto si el contexto es >70%

#### Continuación y reanudación de la sesión

Claude Code permite **continuar conversaciones anteriores** a través de sesiones de terminal, manteniendo el contexto completo y el historial de conversaciones.

**Dos formas de reanudar**:

1. **Continuar la última sesión** (`--continue` o `-c`): 
```bash
# Reanuda automáticamente tu conversación más reciente 
claude --continue 
# Forma corta 
claude -c 
```

1. **Reanudar sesión específica** (`--resume <id>` o `-r <id>`): 
```bash
# Reanudar una sesión específica por ID 
claude --resume abc123def 
# Forma corta 
claude -r abc123def 
```

1. **Enlace a un PR de GitHub** (`--from-pr <número>`, v2.1.49+): 
```bash
# Iniciar una sesión vinculada a un PR específico 
claude --from-pr 123 

# Sesiones creadas a través de gh pr create durante una sesión de Claude 
# están vinculados automáticamente a ese PR: use --from-pr para reanudarlos 
gh pr create --title "Agregar autenticación" --body "..." 
# Más tarde: 
claude --from-pr 123 # Reanuda el contexto de la sesión para este PR 
``` 

Útil para continuar trabajando en una función exactamente donde lo dejó en relación con un PR específico; no es necesario recordar los ID de sesión.

**Encontrar ID de sesión**:

```bash
# Nativo: selector de sesión interactivo
claude --resume

# Las sesiones también se muestran al salir.
Vos: /exit
ID de sesión: abc123def (guardado para reanudar)
```

**Casos de uso comunes**:

| Escenario | Comando | Por qué |
|----------|---------|-----|
| Trabajo interrumpido | `claude -c` | Continuar exactamente donde lo dejaste |
| Función de varios días | `claude -r abc123` | Continuar tarea compleja a lo largo de los días |
| Después del descanso/reunión | `claude -c` | Reanudar sin perder contexto |
| Proyectos paralelos | `claude -r <id>` | Cambiar entre diferentes contextos de proyectos |
| Seguimiento de la revisión del código | `claude -r <id>` | Abordar los comentarios de revisión en el contexto original |

**Ejemplo de flujo de trabajo**:

```bash
# Día 1: Comenzar a implementar la autenticación
cd ~/proyecto
claude
Vos: Implementar la autenticación JWT con tokens de actualización
Claude: [Análisis e implementación inicial]
Tu: /exit
ID de sesión: auth-feature-xyz (27% de contexto utilizado)

# Día 2: Continuar el trabajo
cd ~/proyecto
claude --continue
Claude: Reanudando sesión auth-feature-xyz...
Vos: Agregar limitación de velocidad a los puntos finales de autenticación
Claude: [Continúa con el contexto completo del trabajo del día 1]
```

**Mejores prácticas**:

- **Utilizar `/exit` correctamente**: salga siempre con `/exit` o `Ctrl+D` (no forzar la finalización) para garantizar que se guarde la sesión.
- **Mensajes finales descriptivos**: Finaliza las sesiones con contexto ("Listo para probar") para que recuerdes el estado al reanudarlas
- **Gestión de contexto proactiva**: Supervise con `/status` y utilice umbrales respaldados por investigaciones: 
- **Contexto**:
  - **< 70%**: Óptimo: capacidad de razonamiento total 
  - **75%**: activadores de compactación automática: Claude Code se comprime automáticamente 
  - **95 %**: transferencia forzada: degradación grave de la calidad, reinicio inmediato
- **Nombres de sesiones**: utilizar `/rename` para dar nombres descriptivos a las sesiones, algo fundamental cuando se ejecutan varias sesiones en paralelo.

**Reanudar frente a empezar de nuevo**:

| Usar /resume cuando... | Empezar de nuevo /clear cuando... |
|-------------------|---------------------|
| Continua con una función/tarea específica | Cambiar a un trabajo no relacionado |
| Aprovechando decisiones anteriores | La sesión anterior se desvió |
| El contexto sigue siendo relevante (< 75%) | El contexto está inflado (>85%) |
| Implementación de varios pasos en progreso | Preguntas rápidas y puntuales |

**Limitaciones**:

- Las sesiones se almacenan localmente (no se sincronizan entre máquinas)
- Es posible que se eliminen sesiones muy antiguas (depende de los límites de almacenamiento local)
- Las sesiones dañadas no se pueden reanudar (comience de nuevo con `/clear`)
- No se pueden reanudar las sesiones iniciadas con un modelo diferente o configuración de MCP

**Preservación del contexto**:

Al reanudar, Claude conserva:
- ✅ Historial de conversaciones completo
- ✅ Archivos previamente leídos/editados
- ✅ CLAUDE.md y configuración del proyecto
- ✅ Estado del servidor MCP
- ✅ El código no comprometido cambia el conocimiento


> **💡 Consejo profesional**: utilice `claude -c` como forma predeterminada de iniciar Claude Code en proyectos activos. Esto garantiza que nunca perderá el contexto de sesiones anteriores a menos que desee explícitamente comenzar de nuevo con `claude`.

### Descubrimiento de patrones de sesión

El historial de sesiones es una fuente de datos.
Cada vez que se le pide a Claude que haga el mismo tipo de cosas en varias sesiones, es una señal:
1. Extraer como una Skill
2. Comando o regla CLAUDE.md
3. Dejar de pagar el impuesto de contexto en cada solicitud.

`cc-sessions discover` automatiza este análisis. Lee tú historial de sesiones, encuentra patrones recurrentes en los mensajes de los usuarios y le dice qué extraer.

**Instalar**:

```bash
curl -sL https://raw.githubusercontent.com/FlorianBruniaux/cc-sessions/main/cc-sessions \ 
-o ~/.local/bin/cc-sessions && chmod +x ~/.local/bin/cc-sessions
```

**Dos modos**:

| Modo | Cómo | Costo | Velocidad |
|------|-----|------|-------|
| N-grama (predeterminado) | Tokeniza mensajes y crea un índice de frecuencia de frases de 3 a 6 palabras | Gratis, local | ~3 segundos para 12 proyectos |
| `--llm` | Deduplica mensajes, envía lotes a `claude --print` | Utiliza tu suscripción | ~15s |

```bash
# Modo N-gram: todos los proyectos, últimos 90 días
cc-sessions --all discover

# Umbral inferior, ventana más estrecha
cc-sessions --all discover --since 60d --min-count 2 --top 15

# Análisis semántico mediante claude --print
cc-sessions --all discover --llm

# Salida JSON para secuencias de comandos
cc-sessions --all discover --json | jq '.[] | select(.category == "skill")'
```

**Salida de ejemplo**:

``` 
cc-sessions discover — 847 sesiones · 12 proyecto(s) · desde 90d 

📋 CLAUDE.md RULE
────────────────────────────── ────────────────────────────── 
Escribir pruebas antes de la implementación 
234 sesiones (28%) · 891 ocurrencias · puntuación 0,416 
→ 3a72f1c4-... 

🧩 SKILL 
────────────────────────────── ────────────────────────────── 
Flujo de autenticación de revisión de seguridad 
71 sesiones (8%) · 203 ocurrencias · puntuación 0,084 
→ 9f1c3a22-... 

⚡ COMMAND 
────────────────────────────── ────────────────────────────── 
Generar script de reversión de migración de prisma 
18 sesiones (2%) · 44 ocurrencias · puntuación 0,021 
→ 44aab71c-...
```

**La regla del 20% incorporada en la puntuación**: los patrones por encima del 20% de las sesiones se convierten en sugerencias de `CLAUDE.md rule` (siempre cargar), del 5 al 20% se convierten en sugerencias de `skill` (carga bajo demanda), por debajo del 5% se convierten en sugerencias de `command` (invocación explícita). La bonificación entre proyectos (1,5 ×) prioriza los patrones que se repiten en diferentes bases de código; vale la pena extraerlos incluso con menor frecuencia.

Véase también: [§5.1 Comprensión de las habilidades](#51-understanding-skills) para la distinción entre las rules, skills y commands de CLAUDE.md, y la [regla del 20%](#the-20-rule) para el marco de decisión.

**GitHub**: [FlorianBruniaux/cc-sessions](https://github.com/FlorianBruniaux/cc-sessions)


## 1.3 Modos de permiso

Claude Code tiene cinco modos de permiso que controlan cuánta autonomía tiene:

### Modo predeterminado

Claude pide permiso antes de:
- Editar de archivos
- Ejecutar comandos
- Hacer compromisos

Este es el modo más seguro para aprender.

### Modo de aceptación automática (`acceptEdits`)

```
Vos: activar la aceptación automática durante el resto de esta sesión.
```

Claude aprueba automáticamente las ediciones de archivos pero aún solicita comandos de shell. Usar cuando confíes en las ediciones y necesites velocidad.

⚠️ **Advertencia**: Utilizar únicamente la aceptación automática para operaciones reversibles y bien definidas.

### Modo de planificación

```
/plan
```

Claude sólo puede leer y analizar, no se permiten modificaciones. Perfecto para:
- Comprender código desconocido
- Explorar opciones arquitectónicas.
- Investigación segura antes de cambios.

Salir de la fase de planificación con `/execute` cuando estés listo para realizar cambios.

### Modo No preguntar (`dontAsk`)

Deniega automáticamente las herramientas a menos que estén aprobadas previamente mediante las reglas `/permissions` o `permissions.allow`. Claude nunca interrumpe con solicitudes de permiso: si una herramienta no está permitida explícitamente, se niega silenciosamente.

Usar para flujos de trabajo restrictivos en los que desee un control estricto sobre qué herramientas se ejecutan, sin confirmación interactiva.

### Modo de omisión de permisos (`bypassPermissions`)

Aprueba todo automáticamente, incluidos los comandos de shell. No hay ninguna solicitud de permiso.

⚠️ **Advertencia**: Usar únicamente en entornos de CI/CD con espacio aislado. Requiere `--dangerfully-skip-permissions` para habilitarlo desde CLI. Nunca lo use en sistemas de producción o con código que no sea de confianza.

## 1.4 Calibración de confianza: cuándo y cuánto verificar

El código generado por IA requiere **verificación proporcional** según el nivel de riesgo. Aceptar ciegamente todos los resultados o revisar paranoicamente cada línea es una pérdida de tiempo. La idea de sección es calibrar la confianza.

### El problema: la deuda de verificación

Investigaciones muestran consistentemente que el código de IA tiene tasas de defectos más altas que el código escrito por humanos:

| Métrica | IA versus humano | Fuente |
|--------|-------------|--------|
| Errores lógicos | 1,75 veces más | [Estudio ACM, 2025](https://dl.acm.org/doi/10.1145/3716848) |
| Fallos de seguridad | El 45% contiene vulnerabilidades | [Informe Veracode GenAI, 2025](https://veracode.com/blog/genai-code-security-report) |
| Vulnerabilidades XSS | 2,74 veces más | [Estudio de CodeRabbit, 2025](https://coderabbit.ai/blog/state-of-ai-vs-human-code-generación-report) |
| Aumento del tamaño de las relaciones públicas | +18% | [Medusas, 2025](https://jellyfish.co) |
| Incidentes por PR | +24% | [Cortex.io, 2026](https://cortex.io) |
| Tasa de fracaso del cambio | +30% | [Cortex.io, 2026](https://cortex.io) |

**Información clave**: La IA produce código más rápido, pero la verificación se convierte en el cuello de botella. La pregunta no es "¿funciona?" pero "¿cómo sé que funciona?"

### El espectro de verificación

No todo el código necesita el mismo escrutinio. La idea es lograr un punto medio entre el esfuerzo de verificación y el riesgo:

| Tipo de código | Nivel de verificación | Inversión de tiempo | Técnicas |
|-----------|-------------------|-----------------|------------|
| **Repetitivo** (configuraciones, importaciones) | ligero | 10-30 segundos | Ver, estructura de confianza |
| **Funciones de utilidad** (formatters, helpers) | Prueba rápida | 1-2 minutos | Prueba de camino feliz |
| **Lógica de negocio** | Revisión profunda + pruebas | 5-15 minutos | Casos extremos, línea por línea |
| **Seguridad crítica** (autenticación, criptografía, validación de entrada) | Máximo + herramientas | 15-30 minutos | Análisis estático, revisión por pares |
| **Integraciones externas** (API, bases de datos) | Pruebas de integración | 10-20 minutos | Prueba de punto final simulada + real, casos de prueba |


### Antipatterns a evitar

| Antipattern | Problema | Mejor enfoque |
|--------------|---------|-----------------|
| **"Si compila, push"** | Sintaxis ≠ corrección | Ejecutar al menos una prueba |
| **"La IA lo escribió, debe ser seguro"** | La IA se optimiza para lo plausible, no lo seguro | Revisar siempre manualmente el código crítico para la seguridad |
| **"Las pruebas pasan, listo"** | Es posible que las pruebas no cubran el cambio | Verificar la cobertura de prueba de líneas modificadas |
| **"Igual que la última vez"** | Cambios de contexto, la IA puede generar código diferente | Cada generación es independiente |
| **"Es sólo un texto repetitivo"** | Incluso lo repetitivo puede ocultar problemas | Como mínimo, hojear las sorpresas |
