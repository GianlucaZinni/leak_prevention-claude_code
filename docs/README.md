# Claude Code | Leak Prevention
> Guía operativa generada a partir de múltiples guías oficiales, blogs, documentaciones y otras fuentes.

<p align="center">
  <a href="https://github.com/GianlucaZinni/own-claude-code-docs"><img src="https://zerobits.de/wp-content/uploads/2025/11/claude.jpeg" alt="Website"/></a>
</p>

---

**Autor**: Gianluca Zinni | CS Developer

**Escrito con**: Claude (Anthropic) / Codex (GPT) / Hands (own)!!

**Ultima actualización**: Marzo 2026

**Version**: 1.0.0

---

## Antes que nada

**Esta guía no es documentación oficial.** Es un recurso basado en mi exploración por diferentes fuentes durante varios días.

**Lo que no vas a encontrar:**
- Respuestas definitivas (la herramienta es demasiado nueva y salen cosas constantemente)
- Afirmaciones de desempeño comparadas
- Garantía que cualquier técnica funcionará para tu trabajo

**Usar de manera crítica, experimental y bajo tu propio riesgo**

---

# Claude Code 
**No es un chat con acceso a archivos, sino una herramienta de trabajo que usa contexto, herramientas y reglas para operar sobre un proyecto real.**

Claude Code es un entorno agentico para desarrollo que puede leer archivos, proponer cambios, ejecutar comandos, usar integraciones y cerrar loops de trabajo con verificacion. El salto mental importante no es "hablar con un modelo", sino delegar partes del flujo de desarrollo a un sistema con **acceso controlado** al entorno.

| Que es | Donde encaja |
|---|---|
| Asistente de desarrollo con herramientas y contexto de proyecto | Trabajo tecnico sobre codigo, tests, docs, refactors y operaciones repetitivas |
| Motor comun servido en terminal, IDE, desktop y web | Flujo diario de un dev o de un equipo con reglas compartidas |
| Sistema que razona, llama tools y vuelve a razonar | Colaboracion hombre-maquina con supervision, diffs y verificacion |

### Lo que cambia al usarlo bien

- El prompt deja de ser solo texto: pasa a ser instruccion operativa con contexto y herramientas disponibles.
- La sesion deja de ser solo conversacion: se vuelve un loop de plan, ejecucion, revision y validacion.
- El usuario deja de ser "quien pregunta": pasa a ser quien define el alcance y audita el resultado.

### Por qué el Claude Code es diferente

**Cambio de mentalidad clave**: Claude Code es un **sistema de contexto estructurado**, no un chatbot ni una herramienta de autocompletar. La idea de esta herramienta es que se pueda por cada proyecto o a nivel general, construir un contexto persistente (CLAUDE.md, skills, hooks) que se agrava con el tiempo; consultar.


# Recursos interesantes // Infografía
**Guías interactivas muy completas:**
- *https://cc.bruniaux.com/*
- *https://github.com/FlorianBruniaux/claude-cowork-guide*

