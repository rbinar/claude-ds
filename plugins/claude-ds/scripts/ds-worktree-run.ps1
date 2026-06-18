#!/usr/bin/env pwsh
param(
  [Parameter(Mandatory = $true)][string]$Repo,
  [Parameter(Mandatory = $true)][string]$Branch,
  [Parameter(Mandatory = $true)][string]$BriefFile
)
$ErrorActionPreference = "Stop"

if (-not (Test-Path (Join-Path $Repo ".git"))) { Write-Error "Not a git repo: $Repo"; exit 1 }
if (-not (Test-Path $BriefFile)) { Write-Error "Brief file not found: $BriefFile"; exit 1 }

$WT = Join-Path ([System.IO.Path]::GetTempPath()) ("ds-wt-" + [System.IO.Path]::GetRandomFileName().Substring(0, 6))

git -C $Repo fetch origin main 2>$null
git -C $Repo worktree add -b $Branch $WT origin/main

$repoNM = Join-Path $Repo "node_modules"
$wtNM = Join-Path $WT "node_modules"
if ((Test-Path $repoNM) -and -not (Test-Path $wtNM)) {
  New-Item -ItemType Junction -Path $wtNM -Target $repoNM | Out-Null
}

Write-Host ">>> Running claude-ds (agentic) in $WT ..."
$brief = Get-Content -Raw $BriefFile
Push-Location $WT
try { claude-ds --dangerously-skip-permissions -p $brief } catch { } finally { Pop-Location }

Write-Host ">>> Worktree: $WT  (branch: $Branch)"
Write-Host ">>> Review the diff, then YOU handle git/PR/merge. Cleanup:"
Write-Host "    Remove-Item `"$wtNM`" -Force; git -C `"$Repo`" worktree remove `"$WT`" --force; git -C `"$Repo`" worktree prune"
git -C $WT status --short
