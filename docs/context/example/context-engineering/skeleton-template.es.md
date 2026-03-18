# CLAUDE.md - [Nombre del Proyecto]

## Resumen Del Proyecto

[DESCRIPCION DEL PROYECTO]

## Arquitectura

### Stack

| Capa | Tecnología | Versión |
|---|---|---|
| Lenguaje | TypeScript | 5.x |
| Runtime | Node.js | 20.x |
| Framework | [Framework] | x.x |
| Base de datos | [Database] | x.x |
| Testing | [Testing] | x.x |

### Estructura De Carpetas

```text
src/
  api/        handlers de ruta solamente
  services/   lógica de negocio
  db/         persistencia y consultas
```

### Decisiones Clave

- [DECISION 1]
- [DECISION 2]

## Estándares De Código

### TypeScript

- El modo estricto está habilitado.
- Nunca uses `any`.
- Las funciones públicas deben declarar tipo de retorno.

### Nombres

- Archivos: `kebab-case.ts`
- Clases: `PascalCase`
- Funciones y variables: `camelCase`
- Constantes: `SCREAMING_SNAKE_CASE`

### Manejo De Errores

- [REGLAS DE ERRORES]

### Comentarios

- [REGLAS DE COMENTARIOS]

## Flujo De Desarrollo

### Convenciones De Git

- Branches: `[type]/[short-description]`
- Commits: Conventional Commits
- Los commits deben ser atómicos

### Requisitos De PR

- [REGLAS DE PR]

### Setup Local

```bash
[INSTALL COMMAND]
[SETUP COMMAND]
[DEV COMMAND]
```

## Testing

### Framework Y Ubicación

- Framework: [Framework]
- Archivos de test: junto al source o en `__tests__/`
- Ejecutar tests: [TEST COMMAND]

### Qué Requiere Tests

- [REQUISITOS DE TEST]

### Mocking

- [CONVENCIONES DE MOCKING]

## Deploy

### Entornos

| Entorno | Branch | URL | Notas |
|---|---|---|---|
| Local | any | localhost:[PORT] | |
| Staging | main | [STAGING URL] | Auto-deploy |
| Producción | [TAG/BRANCH] | [PROD URL] | Trigger manual |

### Deploy

```bash
[DEPLOY COMMAND]
```

### Checks Post-Deploy

- [CHECKS POST-DEPLOY]

## Qué Claude No Debe Hacer

### Tecnologías Que No Se Usan

- No sugieras GraphQL si REST es el estándar del proyecto.
- No uses librerías que ya fueron reemplazadas.

### Patrones A Evitar

- [ANTI-PATTERN 1]
- [ANTI-PATTERN 2]
- [ANTI-PATTERN 3]

### Zonas Problemáticas Conocidas

- [KNOWN PROBLEM AREA 1]
- [KNOWN PROBLEM AREA 2]
