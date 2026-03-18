# Guía de Configuración

Esta guía describe la superficie de configuración usada para definir el comportamiento de Claude Code en un repositorio: valores compartidos del equipo, sobrescrituras personales, política de sandbox, registro de servidores MCP y plantillas de divulgación para contribuciones. El objetivo es mantener la configuración explícita, revisable y segura de mantener.

## Índice

- [Modelo de Configuración](#modelo-de-configuracion)
- [Precedencia y Alcance](#precedencia-y-alcance)
- [Responsabilidad de Archivos](#responsabilidad-de-archivos)
- [Patrones Operativos](#patrones-operativos)
- [Ejemplo Completo de Extremo a Extremo](#ejemplo-completo-de-extremo-a-extremo)
- [Validación y Mantenimiento](#validacion-y-mantenimiento)

## <a id="modelo-de-configuracion"></a>Modelo de Configuración

La configuración en un repositorio con Claude Code se administra mejor cuando cada responsabilidad tiene un único dueño y un único lugar. La configuración del equipo vive en archivos versionados. Las excepciones específicas de una máquina permanecen locales y sin seguimiento. La política de sandbox limita lo que el asistente puede acceder. Las definiciones MCP describen capacidades externas. Las plantillas para contribuciones definen cómo las personas documentan el uso de IA en el flujo de trabajo.

En la práctica, esto se traduce en un conjunto pequeño de archivos con distintos niveles de confianza:

| Archivo | Propósito | Dueño habitual | Versionado |
| --- | --- | --- | --- |
| `.claude/settings.json` | Valores compartidos y hooks del equipo | Mantenedores del repositorio | Sí |
| `.claude/settings.local.json` | Sobrescrituras personales en una sola máquina | Desarrollador individual | No |
| `.claude/sandbox-native.json` | Perfil local de sandbox más estricto o explícito | Desarrollador individual o responsable de seguridad | Sí, si se usa como ejemplo compartido |
| `.claude/mcp.json` | Registro de servidores MCP | Mantenedores del repositorio | Sí |
| `.gitignore` | Evita commits accidentales de estado local | Mantenedores del repositorio | Sí |
| `.github/PULL_REQUEST_TEMPLATE.md` | Checklist de PR y divulgación de IA | Mantenedores del repositorio | Sí |
| `CONTRIBUTING.md` | Política de contribución y reglas de divulgación | Mantenedores del repositorio | Sí |

## <a id="precedencia-y-alcance"></a>Precedencia y Alcance

Claude Code resuelve la configuración desde afuera hacia adentro. Las entradas de mayor prioridad sobrescriben los valores de menor prioridad, por lo que una sobrescritura local puede ajustar una política compartida sin obligar a cambiar la base del repositorio.

1. Flags de línea de comandos y opciones de tiempo de ejecución.
2. Variables de entorno.
3. Configuración del proyecto.
4. Configuración global del usuario.
5. Valores predeterminados integrados.

Ese orden importa por dos motivos. Primero, mantiene el repositorio reproducible porque la configuración compartida está versionada y visible. Segundo, permite que cada desarrollador tenga un lugar seguro para comportamientos específicos de su máquina sin contaminar la base compartida.

El mismo principio aplica dentro del repositorio:

- La configuración compartida define la experiencia por defecto para todo el equipo.
- La configuración local cambia solo la máquina actual.
- Las reglas del sandbox limitan el acceso a archivos, red y comandos.
- Las definiciones MCP agregan herramientas externas de forma controlada.

## <a id="responsabilidad-de-archivos"></a>Responsabilidad de Archivos

Las siguientes responsabilidades mantienen esta parte de la documentación fácil de mantener.

`settings.json` debe describir el comportamiento que todo el equipo espera. Lo habitual es incluir hooks compartidos, permisos base y cualquier otro ajuste que deba revisarse como parte normal de un pull request. Conviene mantener este archivo conservador. Es la fuente de verdad del proyecto.

`settings.local.json` debe contener excepciones por máquina. Se usa cuando una laptop es más lenta, un servicio local corre en otro puerto o un desarrollador necesita ajustar permisos personales. No debe convertirse en una segunda fuente de verdad oculta para el equipo.

`sandbox-native.json` es útil cuando el proyecto quiere un perfil de sandbox más estricto o explícito que la experiencia por defecto. Documenta qué se puede escribir, qué queda fuera de alcance, qué dominios se pueden consultar y qué comandos no deben ejecutarse bajo sandbox.

`mcp.json` define los servicios externos a los que puede acceder el asistente a través de MCP. Conviene mantener una lista corta e intencional. Es preferible registrar capacidades realmente útiles para el repositorio antes que habilitar todos los servidores posibles.

`.gitignore` debe excluir estado local, archivos temporales y cualquier cosa que pueda filtrar datos sensibles o específicos de una máquina. Si un archivo solo existe en un equipo, no debería versionarse.

`PULL_REQUEST_TEMPLATE.md` y `CONTRIBUTING.md` deben explicar las expectativas sobre el trabajo asistido por IA. El objetivo no es prohibir la IA, sino hacer explícitas las expectativas de revisión y evitar sorpresas durante el code review.

## <a id="patrones-operativos"></a>Patrones Operativos

El patrón más seguro es mantener la configuración compartida pequeña y usar sobrescrituras locales con moderación. Eso le da al repositorio un comportamiento estable por defecto y, al mismo tiempo, tolera distintos entornos de desarrollo.

Para control de acceso, define el sandbox más restrictivo que todavía permita trabajar al proyecto. Niega explícitamente rutas de lectura sensibles, como almacenes de credenciales. Permite solo los dominios de red que sean realmente necesarios para paquetes, control de versiones o una API documentada.

Para automatización, conviene usar un conjunto pequeño de hooks que impongan comportamientos previsibles. Un hook previo a una herramienta es apropiado para bloquear acciones peligrosas o validar entradas. Un hook posterior a una herramienta es apropiado para formateo, notificación o registro.

Para herramientas externas, registra solo los servidores MCP que apoyan el repositorio actual. Un indexador del codebase, un servicio de documentación o un servidor de automatización de navegador suelen ser suficientes. Mantener el conjunto enfocado reduce el costo operativo y la superficie de ataque.

Para la política de contribución, pide divulgación cuando la IA haya contribuido de forma material al código, las pruebas o la documentación. El autocompletado trivial y la asistencia rutinaria del editor no necesitan una carga adicional de divulgación. Una política clara ayuda a que los revisores ajusten su atención sin fricción innecesaria.

## <a id="ejemplo-completo-de-extremo-a-extremo"></a>Ejemplo Completo de Extremo a Extremo

El ejemplo siguiente muestra una configuración completa de repositorio para un workspace seguro de equipo. Cubre la base compartida del equipo, las sobrescrituras locales, la política de sandbox, el registro MCP, la divulgación para contribuciones y las reglas de exclusión. La estructura es lo bastante pequeña como para entenderse de una pasada, pero lo bastante completa como para copiarse en un repositorio real.

```text
team-safe-repo/
|-- .claude/
|   |-- settings.json
|   |-- settings.local.json.example
|   |-- sandbox-native.json
|   |-- mcp.json
|   `-- hooks/
|       |-- security-check.sh
|       `-- auto-format.sh
|-- .github/
|   `-- PULL_REQUEST_TEMPLATE.md
|-- CONTRIBUTING.md
`-- .gitignore
```

### <a id="orden-de-creacion-del-ejemplo"></a>Orden de Creación

Crea los archivos en este orden para que el repositorio permanezca coherente mientras se construye:

1. `.gitignore` para evitar commits accidentales de estado local.
2. `.claude/settings.json` para definir la base compartida.
3. `.claude/hooks/security-check.sh` y `.claude/hooks/auto-format.sh` para implementar automatización compartida.
4. `.claude/mcp.json` para registrar herramientas externas.
5. `.claude/sandbox-native.json` para documentar el perfil de sandbox.
6. `.claude/settings.local.json.example` para mostrar el patrón de sobrescritura local.
7. `CONTRIBUTING.md` y `.github/PULL_REQUEST_TEMPLATE.md` para definir las expectativas de divulgación.

### <a id="archivo-por-archivo-del-ejemplo"></a>Archivo por Archivo

`.gitignore` excluye el archivo de configuración local, el estado temporal de Claude y los logs de depuración. Eso evita que una configuración de una máquina termine como artefacto compartido.

`.claude/settings.json` define los hooks compartidos y un conjunto conservador de permisos base. Es el archivo que el equipo revisa cuando cambia el comportamiento para todos.

`.claude/hooks/security-check.sh` bloquea patrones peligrosos evidentes en shell antes de que se ejecuten. `.claude/hooks/auto-format.sh` demuestra el patrón post-tool para limpieza o formateo.

`.claude/mcp.json` registra un conjunto pequeño de servidores MCP que ayudan al desarrollo sin ampliar el entorno de manera innecesaria.

`.claude/sandbox-native.json` documenta una política de sandbox estricta: rutas de escritura explícitas, lecturas sensibles denegadas, red denegada por defecto y una lista corta de comandos excluidos.

`.claude/settings.local.json.example` muestra cómo un desarrollador puede ajustar una sola máquina sin cambiar la base del proyecto. El ejemplo mantiene estable el repositorio compartido y, al mismo tiempo, permite sobrescrituras personales.

`CONTRIBUTING.md` explica cuándo debe divulgarse el uso de IA. `.github/PULL_REQUEST_TEMPLATE.md` lleva esa regla al flujo de pull requests para que la divulgación ocurra en el punto de revisión.

### <a id="validacion-del-ejemplo"></a>Validación

Después de ensamblar el ejemplo, verifica lo siguiente:

1. `settings.json` está versionado y contiene solo comportamiento compartido.
2. `settings.local.json.example` se trata como plantilla, no como sobrescritura local viva.
3. Los hooks funcionan sin depender de estado oculto fuera del repositorio.
4. La lista de MCP es pequeña y coincide con las necesidades reales del proyecto.
5. La política de sandbox bloquea el acceso sensible por defecto.
6. La plantilla de divulgación aparece en el flujo de revisión y es fácil de completar.

El resultado esperado es un repositorio donde el comportamiento del asistente es explícito, el modelo de sobrescritura local es seguro y los contribuyentes saben cómo documentar la asistencia de IA sin adivinar.

## <a id="validacion-y-mantenimiento"></a>Validación y Mantenimiento

Mantén alineados la guía y la implementación. Cuando se introduzca un nuevo ajuste, hook o servidor MCP, documenta por qué pertenece a la base compartida y si también necesita un ejemplo de sobrescritura local.

Cuando el repositorio crezca, es preferible agregar un archivo de configuración nuevo y enfocado antes que expandir uno existente sin límite. Un conjunto más pequeño de archivos es más fácil de revisar y más fácil de asegurar.

Antes de fusionar un cambio de configuración, valida estos puntos:

- La configuración compartida sigue reflejando el comportamiento por defecto deseado.
- Las sobrescrituras locales siguen siendo opcionales y específicas de la máquina.
- El sandbox sigue denegando el acceso sensible.
- Los servidores externos están limitados al conjunto mínimo requerido.
- Las plantillas de contribución siguen coincidiendo con el proceso de revisión actual.

