<#
.SYNOPSIS
    Dotfiles bootstrap for native Windows.

.DESCRIPTION
    Provisions the bare minimum needed to run the dotfiles on native Windows
    (no WSL): Git for Windows (which ships Git Bash) and winget. It then hands
    off to the existing bash setup script (setup.sh) running under Git Bash.

    There is no PowerShell port of the setup logic — one bash codebase serves
    macOS, Linux, WSL and Windows. Actual package installation happens later,
    inside install.sh, after the interactive checkbox selection in setup.sh.

.NOTES
    Run from the repository root in a PowerShell window:

        .\bootstrap.ps1

    Developer Mode is recommended so setup.sh can create real symlinks; if it
    is off, configs are copied instead (a warning is shown, not a failure).
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

# ----------------------------------------------------------------------------
# Output helpers
# ----------------------------------------------------------------------------
function Write-Step    { param($m) Write-Host "==> $m" -ForegroundColor Cyan }
function Write-Ok      { param($m) Write-Host "  + $m" -ForegroundColor Green }
function Write-Warn    { param($m) Write-Host "  ! $m" -ForegroundColor Yellow }
function Write-Err     { param($m) Write-Host "  x $m" -ForegroundColor Red }

function Write-Banner {
    Write-Host ""
    Write-Host "+======================================================+" -ForegroundColor Cyan
    Write-Host "|            Dotfiles Bootstrap (Windows)              |" -ForegroundColor Cyan
    Write-Host "+======================================================+" -ForegroundColor Cyan
    Write-Host ""
}

# ----------------------------------------------------------------------------
# 1. Require Windows 10 or newer
# ----------------------------------------------------------------------------
function Assert-WindowsVersion {
    $major = [Environment]::OSVersion.Version.Major
    if ($major -lt 10) {
        Write-Err "Windows 10 or newer is required (detected major version $major)."
        exit 1
    }
    Write-Ok "Windows $major detected."
}

# ----------------------------------------------------------------------------
# 2. Ensure winget is available
# ----------------------------------------------------------------------------
# winget cannot reliably self-install, so if it is missing we point the user at
# the Microsoft Store and stop here.
function Assert-Winget {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Ok "winget is available."
        return
    }
    Write-Err "winget was not found."
    Write-Host ""
    Write-Host "  winget ships with the 'App Installer' package. Install it from the" -ForegroundColor Yellow
    Write-Host "  Microsoft Store, then re-run this script:" -ForegroundColor Yellow
    Write-Host "    https://apps.microsoft.com/detail/9NBLGGH4NNS1" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# ----------------------------------------------------------------------------
# 3. Ensure Git for Windows (provides Git Bash) is installed
# ----------------------------------------------------------------------------
function Find-GitBash {
    $candidates = @(
        "$env:ProgramFiles\Git\bin\bash.exe",
        "${env:ProgramFiles(x86)}\Git\bin\bash.exe",
        "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
    )
    foreach ($c in $candidates) {
        if ($c -and (Test-Path $c)) { return $c }
    }
    $cmd = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

function Install-Git {
    if (Find-GitBash) {
        Write-Ok "Git for Windows is already installed."
        return
    }
    Write-Step "Installing Git for Windows via winget..."
    winget install --exact --id Git.Git --silent `
        --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Err "winget failed to install Git.Git (exit code $LASTEXITCODE)."
        exit 1
    }
    Write-Ok "Git for Windows installed."
}

# ----------------------------------------------------------------------------
# 4. Check Developer Mode (needed for native symlinks)
# ----------------------------------------------------------------------------
function Test-DeveloperMode {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
    try {
        $value = (Get-ItemProperty -Path $key -Name AllowDevelopmentWithoutDevLicense `
                    -ErrorAction Stop).AllowDevelopmentWithoutDevLicense
        return ($value -eq 1)
    } catch {
        return $false
    }
}

function Check-DeveloperMode {
    if (Test-DeveloperMode) {
        Write-Ok "Developer Mode is enabled (native symlinks will work)."
        return
    }
    Write-Warn "Developer Mode is OFF."
    Write-Host ""
    Write-Host "  Without it, setup.sh copies config files instead of symlinking" -ForegroundColor Yellow
    Write-Host "  them, so edits in the repo won't propagate live until you re-run" -ForegroundColor Yellow
    Write-Host "  setup. To enable it:" -ForegroundColor Yellow
    Write-Host "    Settings > Privacy & security > For developers > Developer Mode" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  This is a warning, not a failure — bootstrap will continue." -ForegroundColor Yellow
    Write-Host ""
}

# ----------------------------------------------------------------------------
# 5. Hand off to setup.sh under Git Bash
# ----------------------------------------------------------------------------
function Invoke-Setup {
    $bash = Find-GitBash
    if (-not $bash) {
        Write-Err "Could not locate bash.exe even after installing Git."
        Write-Host "  Open a new terminal so PATH refreshes, then re-run bootstrap.ps1." -ForegroundColor Yellow
        exit 1
    }
    Write-Ok "Using Git Bash: $bash"

    # Git Bash accepts forward-slash Windows paths (C:/Users/...).
    $repo = ($PSScriptRoot -replace '\\', '/')

    Write-Step "Handing off to setup.sh under Git Bash..."
    Write-Host ""
    & $bash -lc "cd '$repo' && ./setup.sh"
    exit $LASTEXITCODE
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
Write-Banner
Assert-WindowsVersion
Assert-Winget
Install-Git
Check-DeveloperMode
Invoke-Setup
