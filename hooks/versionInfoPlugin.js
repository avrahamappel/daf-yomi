import { execSync } from 'child_process'
import { writeFileSync } from 'fs'
import { dirname, resolve } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

function versionInfoPlugin() {
  return {
    name: 'version-info-plugin',
    buildStart() {
      try {
        // Get the last commit hash (short form)
        const commitHash = execSync('git rev-parse --short HEAD', { encoding: 'utf-8' }).trim()

        // Get the last commit date in ISO format (YYYY-MM-DD)
        const commitDate = execSync('git log -1 --format=%cs', { encoding: 'utf-8' }).trim()

        // Generate the Version.elm file
        const versionElm = `module Version exposing (date, commit)

{-| Version information generated at build time -}

date : String
date = "${commitDate}"


commit : String
commit = "${commitHash}"
`

        // Write to src/Version.elm
        const versionFilePath = resolve(__dirname, '../src/Version.elm')
        writeFileSync(versionFilePath, versionElm)

        console.log(`✓ Generated Version.elm`)
        console.log(`  Date: ${commitDate}`)
        console.log(`  Commit: ${commitHash}`)

      } catch (error) {
        console.error('Error generating version file:', error.message)
        process.exit(1)
      }
    }
  }
}

export default versionInfoPlugin;
