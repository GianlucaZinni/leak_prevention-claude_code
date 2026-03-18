# Ejemplos De Complementos

Este documento reúne ejemplos practicos que muestran como se combinan los conceptos de complementos en escenarios reales. Cada ejemplo es pequeno a proposito, pero describe un patron completo de uso en lugar de fragmentos aislados.

## Indice

1. Complemento minimo de saludo
2. Complemento de revision de codigo con skill con namespace
3. Complemento con hook posterior a la edicion
4. Conversion de configuracion independiente a complemento
5. Instalacion y uso de un complemento de marketplace

## 1. Complemento Minimo De Saludo

Este es el complemento util mas pequeno: un manifiesto y una skill. Es un buen punto de partida para validar la estructura de directorios y la invocacion con namespace.

### Estructura

```text
greeting-plugin/
|-- .claude-plugin/
|   `-- plugin.json
`-- skills/
    `-- hello/
        `-- SKILL.md
```

### Manifiesto

```json
{
  "name": "greeting-plugin",
  "description": "A small plugin that greets the user",
  "version": "1.0.0"
}
```

### Skill

```markdown
---
description: Greet the user with a friendly message
---

Greet the user warmly and ask how you can help.
```

### Como Usarlo

```bash
claude --plugin-dir ./greeting-plugin
```

Luego invoca la skill con el namespace del complemento:

```text
/greeting-plugin:hello
```

Este ejemplo sirve para comprobar todo el recorrido desde el manifiesto hasta la invocacion con el minimo de piezas.

## 2. Complemento De Revision De Codigo Con Skill Con Namespace

Este ejemplo muestra un complemento de equipo mas realista. La skill es opinada, reutilizable y adecuada para un flujo de trabajo compartido entre ingenieros.

### Estructura

```text
team-review-kit/
|-- .claude-plugin/
|   `-- plugin.json
`-- skills/
    `-- code-review/
        `-- SKILL.md
```

### Definicion De La Skill

```markdown
---
description: Review code for correctness, security, and maintainability
---

# Code Review Skill

Review the change set as a senior engineer.

Check for:
- behavioral correctness
- edge cases
- security issues
- test coverage
- maintainability and clarity
```

### Por Que Importa

Este patron escala bien porque la skill se puede reutilizar en varios repositorios sin cambiar la forma de invocacion. El namespace evita colisiones con skills del mismo nombre en otros complementos.

## 3. Complemento Con Hook Posterior A La Edicion

Este ejemplo agrega automatizacion. Es una buena opcion cuando quieres que un comando se ejecute despues de cambios en archivos sin depender de que el usuario lo recuerde.

### Estructura

```text
formatter-plugin/
|-- .claude-plugin/
|   `-- plugin.json
`-- hooks/
    `-- hooks.json
```

### Configuracion Del Hook

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint:fix"
          }
        ]
      }
    ]
  }
}
```

### Por Que Importa

Esta es la forma correcta de modelar tareas de cumplimiento o higiene. El hook se ejecuta porque un archivo cambio, no porque una persona recordo dispararlo manualmente.

## 4. Conversion De Configuracion Independiente A Complemento

Este ejemplo representa la migracion mas comun para un proyecto que ya tiene personalizaciones locales y quiere compartirlas.

### Antes

```text
.claude/
|-- commands/
|-- agents/
`-- settings.json
```

### Despues

```text
my-plugin/
|-- .claude-plugin/
|   `-- plugin.json
|-- commands/
|-- agents/
`-- hooks/
    `-- hooks.json
```

### Pasos De Migracion

1. Crear la raiz del complemento y el manifiesto.
2. Mover los artefactos reutilizables a la raiz del complemento.
3. Convertir los hooks definidos por settings en `hooks/hooks.json`.
4. Probar localmente con `claude --plugin-dir`.
5. Recargar los complementos y verificar los comandos con namespace.

### Por Que Importa

Esta conversion cambia una configuracion limitada a un proyecto en un paquete reutilizable. El valor real no es mover carpetas, sino poder versionar y distribuir el comportamiento de forma limpia.

## 5. Instalacion Y Uso De Un Complemento De Marketplace

Este ejemplo muestra el flujo habitual de consumo para un complemento que no escribiste.

### Agregar Un Marketplace

```text
/plugin marketplace add anthropics/claude-code
```

### Instalar Un Complemento

```text
/plugin install commit-commands@anthropics-claude-code
```

### Recargar Y Usar

```text
/reload-plugins
/commit-commands:commit
```

### Por Que Importa

Este es el patron operativo para equipos que quieren capacidades curadas sin copiar configuraciones a mano. El marketplace aporta discovery y el namespace del complemento mantiene explicito el comportamiento instalado.

## Guia Practica

Al construir o instalar un complemento, conviene tener presentes tres cosas. Primero, valida la estructura en la raiz antes de depurar el comportamiento. Segundo, recarga los complementos despues de cada cambio. Tercero, trata como codigo privilegiado cualquier complemento que pueda ejecutar comandos o cargar integraciones externas.

Si un complemento supera el nivel de ejemplo trivial, documenta su proposito, su namespace esperado y su modelo de confianza junto con la implementacion. Eso facilita que otros ingenieros decidan si corresponde usarlo en su entorno.
