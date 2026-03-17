
# Mejores prácticas de prompting

Guía completa sobre técnicas de ingeniería de prompts para los modelos más recientes de Claude, incluyendo claridad, ejemplos, estructuración con XML, razonamiento (“thinking”) y sistemas agenticos.

---

Esta es la referencia principal para ingeniería de prompts con los modelos más recientes de Claude, incluyendo **Claude Opus 4.6**, **Claude Sonnet 4.6** y **Claude Haiku 4.5**. Cubre técnicas fundamentales, control de salida, uso de herramientas, razonamiento y sistemas agenticos.

---

# Principios generales

## Ser claro y directo

Claude responde mejor a **instrucciones claras y explícitas**. Ser específico sobre el resultado deseado mejora significativamente los resultados.

Piensa en Claude como un **empleado extremadamente brillante pero nuevo**, que no conoce tus normas ni tu workflow.

Cuanto más preciso seas al explicar lo que necesitas, mejor será el resultado.

Buenas prácticas:

- Especificar el **formato de salida esperado**
- Explicar **restricciones**
- Dar instrucciones **paso a paso**
- Usar **listas numeradas** cuando el orden importa

### Ejemplo

Menos efectivo:

```
Create an analytics dashboard
```

Más efectivo:

```
Create an analytics dashboard. Include as many relevant features and interactions as possible. 
Go beyond the basics to create a fully-featured implementation.
```

---

## Agregar contexto mejora el rendimiento

Explicar **por qué una instrucción es importante** ayuda al modelo a comprender mejor el objetivo.

Ejemplo:

Menos efectivo:

```
NEVER use ellipses
```

Más efectivo:

```
Your response will be read aloud by a text-to-speech engine, so never use ellipses 
since the text-to-speech engine will not know how to pronounce them.
```

Claude es capaz de **generalizar a partir de la explicación**.

---

## Usar ejemplos de forma efectiva

Los ejemplos son una de las formas más confiables de controlar:

- formato de salida
- tono
- estructura

Esto se conoce como **few‑shot prompting**.

Buenas prácticas:

- **Relevantes**: deben parecerse al caso real
- **Diversos**: cubrir edge cases
- **Estructurados**: usar tags `<example>`

Cantidad recomendada:

**3 a 5 ejemplos**.

También puedes pedirle a Claude que genere más ejemplos.

---

# Estructurar prompts con XML

Los **tags XML** ayudan a Claude a interpretar prompts complejos.

Especialmente cuando se mezclan:

- instrucciones
- contexto
- ejemplos
- inputs variables

Ejemplo de estructura:

```
<instructions>
...
</instructions>

<context>
...
</context>

<input>
...
</input>
```

Buenas prácticas:

- usar nombres de tags claros
- mantener consistencia
- anidar tags cuando hay jerarquía

---

# Asignar un rol al modelo

Definir un rol en el system prompt cambia significativamente el comportamiento del modelo.

Ejemplo:

```python
system="You are a helpful coding assistant specializing in Python."
```

Esto guía:

- tono
- estilo
- dominio técnico

---

# Prompts con contexto largo

Cuando se trabaja con documentos largos (>20k tokens):

## Colocar datos largos al inicio

Los documentos grandes deben colocarse **antes de las instrucciones**.

Esto mejora el rendimiento.

Las pruebas muestran que poner la pregunta **al final** puede mejorar la calidad de respuesta hasta **30%**.

---

## Estructurar múltiples documentos

Ejemplo:

```xml
<documents>
  <document index="1">
    <source>annual_report.pdf</source>
    <document_content>
      ...
    </document_content>
  </document>
</documents>
```

---

## Citar partes relevantes

Pedir al modelo que cite información antes de analizarla ayuda a reducir ruido.

Ejemplo:

```
Find quotes relevant to the diagnosis and place them in <quotes> tags.
```

---

# Conocimiento del modelo

Si necesitas que Claude se identifique correctamente:

```
The assistant is Claude, created by Anthropic.
The current model is Claude Opus 4.6.
```

---

# Formato de salida

## Estilo de comunicación

Los modelos recientes de Claude son:

- más concisos
- más naturales
- menos verbosos

A veces omiten resúmenes después de usar herramientas.

Si necesitas más explicación:

```
After completing a task, provide a quick summary.
```

---

## Controlar el formato de respuestas

Estrategias efectivas:

### 1. Decir qué hacer en lugar de qué evitar

Malo:

```
Do not use markdown
```

Mejor:

```
Write your response in clear prose paragraphs.
```

### 2. Usar XML

```
<smoothly_flowing_prose_paragraphs>
...
</smoothly_flowing_prose_paragraphs>
```

### 3. Alinear estilo del prompt con la salida

El estilo del prompt influye en el estilo de respuesta.

---

# Salida LaTeX

Claude Opus 4.6 usa **LaTeX por defecto para matemáticas**.

Si quieres texto plano:

```
Format your response in plain text only. 
Do not use LaTeX or MathJax.
```

---

# Creación de documentos

Claude puede crear:

- presentaciones
- animaciones
- documentos visuales

Prompt recomendado:

```
Create a professional presentation on [topic]. 
Include thoughtful design elements and visual hierarchy.
```

---

# Uso de herramientas

## Instrucciones explícitas

Claude sigue instrucciones literalmente.

Ejemplo:

Menos efectivo:

```
Can you suggest some changes?
```

Más efectivo:

```
Change this function to improve performance.
```

---

## Modo proactivo

Puedes configurar el system prompt:

```
<default_to_action>
Implement changes rather than only suggesting them.
</default_to_action>
```

---

# Ejecución paralela de herramientas

Los modelos recientes pueden ejecutar múltiples herramientas en paralelo:

- leer varios archivos
- ejecutar múltiples comandos
- hacer múltiples búsquedas

Prompt para maximizar paralelismo:

```
If multiple tool calls are independent, execute them in parallel.
```

---

# Thinking y razonamiento

Claude Opus 4.6 puede hacer **exploración inicial extensa**.

Esto mejora resultados pero puede aumentar latencia.

Para limitarlo:

```
Choose an approach and commit to it.
Avoid revisiting decisions unnecessarily.
```

---

# Adaptive Thinking

Claude 4.6 usa **adaptive thinking**.

El modelo decide automáticamente:

- cuándo pensar
- cuánto pensar

Esto depende de:

- complejidad de la pregunta
- parámetro `effort`

Opciones:

- low
- medium
- high
- max

---

# Sistemas agenticos

Claude es muy bueno en:

- tareas largas
- razonamiento multietapa
- seguimiento de estado

Puede trabajar en múltiples sesiones guardando estado.

---

# Gestión de estado

Buenas prácticas:

- usar JSON para estado estructurado
- usar texto libre para progreso
- usar Git para checkpoints

Ejemplo:

```
tests.json
progress.txt
```

---

# Balance entre autonomía y seguridad

Claude puede ejecutar acciones riesgosas como:

- borrar archivos
- force push
- modificar infraestructura

Puedes pedir confirmación:

```
Ask the user before performing destructive operations.
```

---

# Investigación

Claude puede realizar búsquedas complejas.

Buenas prácticas:

- definir criterios de éxito
- verificar múltiples fuentes
- mantener notas de investigación

---

# Evitar sobre‑ingeniería

Claude puede crear:

- archivos extra
- abstracciones innecesarias
- complejidad excesiva

Prompt recomendado:

```
Avoid over‑engineering. 
Only implement what was requested.
Keep solutions minimal.
```

---

# Evitar soluciones hardcoded

```
Do not hard‑code values.
Implement general solutions.
Tests verify correctness but do not define the solution.
```

---

# Reducir alucinaciones

```
Never speculate about code you have not opened.
Always read the relevant files first.
```

---

# Capacidades visuales

Claude 4.6 tiene mejores capacidades para:

- análisis de imágenes
- extracción de datos
- interpretación de UI

Un método útil es darle una herramienta de **crop / zoom**.

---

# Diseño frontend

Claude puede crear aplicaciones web completas.

Pero puede producir estética genérica ("AI slop").

Para mejorar diseño:

- usar tipografías distintivas
- definir paleta visual fuerte
- usar animaciones
- evitar layouts genéricos

---

# Consideraciones de migración

Al migrar a Claude 4.6:

1. Ser más específico en prompts
2. Pedir features explícitamente
3. Usar `effort` en lugar de `budget_tokens`
4. Eliminar prefills
5. Ajustar prompts anti‑lazy

---

# Configuración recomendada de effort

General:

- **low** → alto volumen
- **medium** → mayoría de aplicaciones
- **high** → problemas complejos

---

# Cuándo usar Opus vs Sonnet

Usar **Opus 4.6** cuando:

- investigación profunda
- migraciones grandes de código
- tareas autónomas largas

Usar **Sonnet 4.6** cuando:

- velocidad importa
- costo importa
- desarrollo general
