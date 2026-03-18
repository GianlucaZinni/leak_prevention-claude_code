#!/usr/bin/env ts-node
/**
 * Context assembler.
 *
 * Builds CLAUDE.md from a developer profile plus shared markdown modules.
 * The script is intentionally small and explicit so the generated output is easy
 * to audit and regenerate.
 */

import fs from 'fs'
import path from 'path'
import yaml from 'js-yaml'

interface Profile {
  profile: {
    name: string
    role: string
    seniority: string
    tools: {
      primary_lang: string
      frontend?: string
      backend?: string
      database?: string
      cloud?: string
      test_framework?: string
    }
    style: {
      verbosity: 'verbose' | 'concise' | 'minimal'
      comment_style: 'none' | 'inline' | 'jsdoc'
      test_coverage: 'none' | 'optional' | 'required'
    }
  }
  modules: {
    include: string[]
    exclude: string[]
  }
  overrides: {
    custom_rules: string[]
  }
}

interface AssemblyResult {
  content: string
  totalChars: number
  estimatedTokens: number
  modulesLoaded: number
  modulesMissing: string[]
  importsResolved: number
}

function readProfile(profilePath: string): Profile {
  if (!fs.existsSync(profilePath)) {
    throw new Error(`Profile not found: ${profilePath}`)
  }

  const raw = fs.readFileSync(profilePath, 'utf8')
  return yaml.load(raw) as Profile
}

function resolveImports(content: string, baseDir: string, depth = 0): string {
  if (depth > 5) {
    return content
  }

  return content.replace(/^@(.+)$/gm, (_, importPath) => {
    const fullPath = path.resolve(baseDir, importPath.trim())
    if (!fs.existsSync(fullPath)) {
      return `<!-- @import ${importPath} - file not found -->`
    }

    const imported = fs.readFileSync(fullPath, 'utf8')
    return resolveImports(imported, path.dirname(fullPath), depth + 1)
  })
}

function loadModule(
  modulePath: string,
  modulesDir: string,
  result: AssemblyResult
): string {
  const fullPath = path.resolve(modulesDir, modulePath)
  if (!fs.existsSync(fullPath)) {
    result.modulesMissing.push(modulePath)
    return ''
  }

  const raw = fs.readFileSync(fullPath, 'utf8')
  const resolved = resolveImports(raw, path.dirname(fullPath))
  const importsInFile = (raw.match(/^@.+$/gm) || []).length

  result.importsResolved += importsInFile
  result.modulesLoaded += 1
  return resolved
}

function buildHeader(profile: Profile): string {
  const { name, role, seniority, tools, style } = profile.profile
  const stack = [
    tools.primary_lang,
    tools.frontend,
    tools.backend,
    tools.database,
    tools.cloud,
    tools.test_framework,
  ].filter(Boolean)

  return [
    '# CLAUDE.md',
    `# Assembled for: ${name} | Role: ${role} | Seniority: ${seniority}`,
    `# Generated: ${new Date().toISOString().split('T')[0]}`,
    `# Stack: ${stack.join(' + ')}`,
    `# Style: verbosity=${style.verbosity}, comments=${style.comment_style}, tests=${style.test_coverage}`,
    '',
  ].join('\n')
}

function buildOverrides(rules: string[]): string {
  if (rules.length === 0) {
    return ''
  }

  return ['## Personal Rules', '', ...rules.map((rule) => `- ${rule}`), ''].join('\n')
}

function assemble(
  profilePath: string,
  outputPath: string,
  modulesDir: string,
  dryRun: boolean
): AssemblyResult {
  const profile = readProfile(profilePath)
  const result: AssemblyResult = {
    content: '',
    totalChars: 0,
    estimatedTokens: 0,
    modulesLoaded: 0,
    modulesMissing: [],
    importsResolved: 0,
  }

  const sections: string[] = [buildHeader(profile)]

  for (const modulePath of profile.modules.include) {
    if (profile.modules.exclude.includes(modulePath)) {
      continue
    }

    const content = loadModule(modulePath, modulesDir, result)
    if (content) {
      sections.push(`<!-- Module: ${modulePath} -->`)
      sections.push(content.trim())
    }
  }

  const overrides = buildOverrides(profile.overrides.custom_rules)
  if (overrides) {
    sections.push(overrides)
  }

  result.content = sections.join('\n\n')
  result.totalChars = result.content.length
  result.estimatedTokens = Math.round(result.totalChars / 4)

  if (!dryRun) {
    fs.mkdirSync(path.dirname(path.resolve(outputPath)), { recursive: true })
    fs.writeFileSync(outputPath, result.content)
  }

  return result
}

function parseArgs(): {
  profilePath: string
  outputPath: string
  modulesDir: string
  dryRun: boolean
} {
  const args = process.argv.slice(2)
  const get = (flag: string, fallback: string): string => {
    const idx = args.indexOf(flag)
    return idx !== -1 && args[idx + 1] ? args[idx + 1] : fallback
  }

  return {
    profilePath: get('--profile', '.claude/profiles/default.yaml'),
    outputPath: get('--output', 'CLAUDE.md'),
    modulesDir: get('--modules', '.claude/modules'),
    dryRun: args.includes('--dry-run'),
  }
}

function main() {
  const { profilePath, outputPath, modulesDir, dryRun } = parseArgs()

  console.log('Context Assembler')
  console.log('=================')
  console.log(`Profile:  ${profilePath}`)
  console.log(`Modules:  ${modulesDir}`)
  console.log(`Output:   ${outputPath}${dryRun ? ' (dry-run)' : ''}`)
  console.log('')

  try {
    const result = assemble(profilePath, outputPath, modulesDir, dryRun)

    console.log('Summary:')
    console.log(`  Modules loaded:    ${result.modulesLoaded}`)
    console.log(`  Modules missing:    ${result.modulesMissing.length}`)
    console.log(`  @imports resolved:  ${result.importsResolved}`)
    console.log(`  Output size:        ${result.totalChars} chars (~${result.estimatedTokens} tokens)`)

    if (result.modulesMissing.length > 0) {
      console.log('')
      console.log('Missing modules:')
      for (const missing of result.modulesMissing) {
        console.log(`  - ${missing}`)
      }
    }

    if (!dryRun) {
      console.log('')
      console.log(`Done: ${outputPath}`)
    }
  } catch (error) {
    console.error(`Error: ${(error as Error).message}`)
    process.exit(1)
  }
}

main()

