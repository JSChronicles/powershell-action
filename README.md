# PowerShell GitHub Actions

<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Psscriptanalyzer][Psscriptanalyzer-badge]][Psscriptanalyzer-url]
[![Pester Test][Pester-Test-badge]][Pester-Test-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">README</h3>

  <p align="center">
    <a href="https://github.com/JSChronicles/powershell-action"><strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/JSChronicles/powershell-action/issues">Report Bug</a>
    ·
    <a href="https://github.com/JSChronicles/powershell-action/issues">Request Feature</a>
  </p>
</div>



## Introduction
This [GitHub Action](https://docs.github.com/en/actions) helps lint and test your PowerShell to make sure that you are putting out production ready and properly tested code.
Below are the modules used to make this happen.

- [pester](./.github/workflows/pester.yaml)
    - [What is pester?](https://pester.dev/docs/quick-start)

- [psscriptanalyzer](./.github/workflows/psscriptanalyzer.yaml)
    - [What is psscriptanalyzer?](https://learn.microsoft.com/en-us/powershell/module/psscriptanalyzer/?view=ps-modules)

## Why Is Linting Important?
Linting is important to reduce errors and improve the overall quality of your code.

## In this repository
- `.github\workflows` folder containing the actual workflows used
    - Check https://github.com/microsoft/psscriptanalyzer-action for more info about the options.
- `tests` folder with samples of working and non-working pester scripts
- `test-scripts` folder with simple sample scripts for linting tests
- `action.yaml` metadata file defines the inputs, outputs, and runs configuration for your action.

## Usage
You can copy down the `.github\workflows` folder and `action.yaml` file into your repository. Remove or add or tweak the `test-scripts` and `tests` files

*or*

You can call the Github Actions by adding the steps below into your workflow.

```yaml
name: Psscriptanalyzer

on:
  push:
    branches:
      - main
      - develop
      - 'release/**'
    paths-ignore:
      - '**.md'
  pull_request:
    branches:
      - main
      - develop
      - 'release/**'
    paths-ignore:
      - '**.md'
      
  workflow_dispatch:

jobs:
  build:
    name: Psscriptanalyzer
    runs-on: ubuntu-latest

    permissions:
      contents: read
      packages: read
      statuses: write
      security-events: write # for github/codeql-action/upload-sarif to upload SARIF results
      actions: read # only required for a private repository by github/codeql-action/upload-sarif to get the Action run status

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Run PSScriptAnalyzer
        uses: JSChronicles/powershell-action@main
        with:
          recurse: true
          output: results.sarif
          enableExit: true

```

```yaml
name: Pester

on:
  push:
    branches:
      - main
      - develop
      - 'release/**'
    paths-ignore:
      - '**.md'
  pull_request:
    branches:
      - main
      - develop
      - 'release/**'
    paths-ignore:
      - '**.md'
      
  workflow_dispatch:

jobs:
  build:
    name: Psscriptanalyzer
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3
        
      - name: Perform all Pester tests from the pester folder
        shell: pwsh
        run: |
          Install-Module -Name Pester -Force
          Import-Module -Name Pester
          Invoke-Pester -Path "./tests/*" -Passthru
          
    if: ${{ always() }}

```

<br>
<br>

# YAML
See the [input section](#Inputs) for more info about the inputs.
```yaml
 - name: Run PSScriptAnalyzer
   uses: psscriptanalyzer-action
   with:
    path:
    customRulePath: 
    recurseCustomRulePath: 
    excludeRule: 
    includeDefaultRules:
    includeRule:
    severity:
    recurse:
    suppressedOnly:
    fix:
    enableExit:
    settings:
    output:
    ignorePattern:
```

# Inputs
The inputs for the action. The inputs `output` and `ignorePattern` are action specific. The rest are mapped to the parameters of PSScriptAnalyzer.
Every input is of type string. 

To provide an array follow the format `'"value.fake", "value1.fake", ....'`
## path
Specifies the path to the scripts or module to be analyzed. Wildcard characters are supported. Default value is: `.\`. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-path).
```yaml
with:
  path: .\
```
```yaml
with:
  path: .\src
```
## customRulePath
Specifies the path to the scripts or module to be analyzed. Wildcard characters are supported. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-customrulepath).
```yaml
with:
  customRulePath: '".\customRule.ps1"'
```
```yaml
with:
  customRulePath: '".\customRule.ps1", "customRule2.ps1"'
```

## recurseCustomRulePath
Uses only the custom rules defined in the specified paths to the analysis. To still use the built-in rules, add the -IncludeDefaultRules switch. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-recursecustomrulepath).
```yaml
with:
  recurseCustomRulePath: true
```
```yaml
with:
  recurseCustomRulePath: false
```

## excludeRule
Omits the specified rules from the Script Analyzer test. Wildcard characters are supported. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-excluderule).
```yaml
with:
  # exclude one rule 
  excludeRule: '"PSAvoidLongLines"'
```
```yaml
with:
  # exclude multiple rules
  excludeRule: '"PSAvoidLongLines", "PSAlignAssignmentStatement"'
```

## includeDefaultRules
Uses only the custom rules defined in the specified paths to the analysis. To still use the built-in rules, add the -IncludeDefaultRules switch. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-includedefaultrules).
```yaml
with:
  includeDefaultRules: true 
```
```yaml
with:
  includeDefaultRules: false
```

## includeRule
Runs only the specified rules in the Script Analyzer test. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-includerule).
```yaml
with:
  # Include one rule
  includeRule: '"PSAvoidUsingInvokeExpression"'
```
```yaml
with:
  # Include multiple rules
  includeRule: '"PSAvoidUsingInvokeExpression", "PSAvoidUsingConvertToSecureStringWithPlainText"' 
```

## severity
After running Script Analyzer with all rules, this parameter selects rule violations with the specified severity. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-severity).
```yaml
with:
  # Report only rule violations with error severity
  severity: '"Error"'
```
```yaml
with:
  # Report only rule violations with error and warning severity
  severity: '"Error", "Warning"'
```
## recurse
Script Analyzer on the files in the Path directory and all subdirectories recursively. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-recurse).
```yaml
with:
  recurse: true
```
```yaml
with:
  recurse: false
```

## suppressedOnly
Returns rules that are suppressed, instead of analyzing the files in the path. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-suppressedonly).
```yaml
with:
  suppressedOnly: true
```
```yaml
with:
  suppressedOnly: false
```

## fix
Fixes certain warnings which contain a fix in their DiagnosticRecord. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-fix).
```yaml
with:
  fix: true
```
```yaml
with:
  fix: false
```

## enableExit
Exits PowerShell and returns an exit code equal to the number of error records. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-enableexit).
```yaml
with:
  enableExit: true
```

```yaml
with:
  enableExit: false
```

## settings
File path that contains user profile or hash table for ScriptAnalyzer. Does not support passing a hashtable as an argument. More info [here](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Cmdlets/Invoke-ScriptAnalyzer.md#-settings).
```yaml
with:
  settings: .\settings.psd1
```

## output
File path that defines where the SARIF output will be stored.
```yaml
with:
  output: results.sarif
```

## ignorePattern
Exclude specific files from the SARIF results. Uses regex pattern.
```yaml
with:
  # Any file or folder that have the name test will not be present in the SARIF file.
  ignorePattern: 'tests'
```

<!-- MARKDOWN LINKS & IMAGES -->
[Psscriptanalyzer-badge]:https://github.com/JSChronicles/powershell-action/actions/workflows/psscriptanalyzer.yaml/badge.svg?branch=main
[Psscriptanalyzer-url]:https://github.com/JSChronicles/powershell-action/actions/workflows/psscriptanalyzer.yaml
[Pester-Test-badge]:https://github.com/JSChronicles/powershell-action/actions/workflows/Pester.yaml/badge.svg?branch=main
[Pester-Test-url]:https://github.com/JSChronicles/powershell-action/actions/workflows/Pester.yaml

