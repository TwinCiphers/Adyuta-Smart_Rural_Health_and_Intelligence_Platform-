import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\android\build.gradle'
with open(path, 'r') as f:
    code = f.read()

replacement = """subprojects {
    afterEvaluate { project ->
        if (project.hasProperty('android')) {
            project.android {
                if (namespace == null) {
                    namespace project.group
                }
            }
        }
        project.tasks.withType(JavaCompile) {
            options.compilerArgs.remove('-Werror')
            options.warnings = false
        }
    }
}"""

code = re.sub(
    r'subprojects \{\s*afterEvaluate \{ project ->.*?\}\s*\}\s*\}',
    replacement,
    code,
    flags=re.DOTALL
)

with open(path, 'w') as f:
    f.write(code)
