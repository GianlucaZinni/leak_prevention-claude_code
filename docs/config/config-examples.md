# Ejemplos de Configuración

Este documento complementario agrupa patrones de configuración concretos que son útiles por sí mismos, pero que no necesitan reemplazar la guía principal. Cada ejemplo es deliberadamente acotado para que pueda copiarse en un repositorio existente con cambios mínimos.

## Índice

- [Sobrescrituras Locales](#sobrescrituras-locales)
- [Perfil de Sandbox](#perfil-de-sandbox)
- [Registro de Servidores MCP](#registro-de-servidores-mcp)
- [Plantillas de Divulgación de IA](#plantillas-de-divulgacion-de-ia)
- [Patrones de Exclusión](#patrones-de-exclusion)

## <a id="sobrescrituras-locales"></a>Sobrescrituras Locales

Usa un archivo de sobrescritura local cuando un desarrollador necesite permisos, hooks o endpoints de servicio distintos. El requisito clave es que el repositorio compartido no cambie.

Casos de uso típicos:

- Portátiles más lentas que necesitan omitir comprobaciones costosas.
- Puertos distintos para una base de datos local.
- Permisos personales que no deben afectar al equipo.

El archivo local debe permanecer sin seguimiento y solo debe contener comportamiento específico de la máquina.

## <a id="perfil-de-sandbox"></a>Perfil de Sandbox

Un perfil de sandbox es útil cuando el repositorio necesita guardrails más fuertes que la experiencia por defecto. Un perfil estricto suele incluir tres ideas: una allowlist corta de rutas de escritura, una denylist de rutas de lectura sensibles y una allowlist pequeña de red.

Mantén el perfil práctico. Si el sandbox es demasiado estricto, los colaboradores lo desactivarán. Si es demasiado permisivo, deja de ser significativo.

## <a id="registro-de-servidores-mcp"></a>Registro de Servidores MCP

Una configuración MCP debería reflejar necesidades reales del proyecto, no capacidad teórica.

Valores de base razonables para muchos repositorios:

- Un indexador del codebase o servidor de memoria.
- Un servidor de consulta de documentación.
- Un servidor de automatización de navegador para pruebas de UI o integración.

Evita registrar servidores que no tengan un uso claro en el repositorio. Cada servidor aumenta el estado del entorno que hay que entender y mantener.

## <a id="plantillas-de-divulgacion-de-ia"></a>Plantillas de Divulgación de IA

La política de divulgación debe ser lo bastante simple como para que los contribuyentes la apliquen sin interpretación.

La regla práctica es:

- Divulgar asistencia de IA material en el pull request.
- No exigir divulgación por autocompletado trivial del editor.
- Mantener el texto breve y factual.

Usa tanto una política de contribución como una plantilla de pull request si el repositorio quiere el recordatorio en dos lugares.

## <a id="patrones-de-exclusion"></a>Patrones de Exclusión

Los patrones de exclusión deben cubrir configuración específica de una máquina, archivos temporales y salidas de depuración. El objetivo es reducir ruido y evitar commits accidentales de estado local.

Exclusiones comunes:

- Archivos de configuración local.
- Memoria local o notas de trabajo.
- Directorios temporales.
- Logs de depuración.

La propiedad importante no es el nombre exacto del archivo. La propiedad importante es que cualquier cosa personal, efímera o sensible quede fuera del control de versiones.

