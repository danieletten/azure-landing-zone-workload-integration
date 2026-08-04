#requires -Version 5
<#
Runs one platform-contract scenario against the working-tree skill using Copilot CLI.
Isolated temp dir, cleaned up after. No secrets, no live Azure. For local repeatability.

Usage:
  run-scenario.ps1 -Id C3 -FixtureDir <dir> -Prompt "<prompt>" -SkillRepo <repo-root> -OutDir <dir>
#>
param(
  [Parameter(Mandatory)] [string]$Id,
  [Parameter(Mandatory)] [string]$FixtureDir,
  [Parameter(Mandatory)] [string]$Prompt,
  [Parameter(Mandatory)] [string]$SkillRepo,
  [Parameter(Mandatory)] [string]$OutDir
)

$ErrorActionPreference = 'Stop'
$work = Join-Path $env:TEMP ("alz-harness-" + $Id + "-" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Force -Path $work | Out-Null
try {
  Copy-Item -Recurse -Force (Join-Path $FixtureDir '*') $work
  gh skill install $SkillRepo azure-landing-zone-workload-integration --from-local --dir (Join-Path $work '.agents\skills') --force *> $null
  Push-Location $work
  git init -q; git commit -q --allow-empty -m init 2>$null | Out-Null
  $full = "$Prompt`n`n(Respond in text only; do NOT run any shell or az commands.)"
  $out = copilot -C $work -p $full --allow-all-tools --no-color 2>&1 | Out-String
  Pop-Location
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
  $outFile = Join-Path $OutDir "$Id.txt"
  Set-Content -Path $outFile -Value $out
  $loaded = if ($out -match 'skill\(azure-landing-zone-workload-integration\)') { 'YES' } else { 'no' }
  [pscustomobject]@{ Id = $Id; SkillLoaded = $loaded; OutputFile = $outFile } | Format-Table -AutoSize
}
finally {
  if (Test-Path $work) { Remove-Item -Recurse -Force $work }
}
