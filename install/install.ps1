# IXIdeal Install Script for Windows
param(
    [string]$PluginName = "ix-ideal"
)

$InstallDir = Join-Path $env:USERPROFILE ".claude\plugins\$PluginName"

Write-Host "Installing $PluginName to $InstallDir..." -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

# 检测安装方式（本地 vs GitHub）
if (Test-Path (Join-Path $RepoDir ".git")) {
    # 从本地仓库安装
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Recurse -Force (Join-Path $RepoDir "skills") $InstallDir
    Copy-Item -Force (Join-Path $RepoDir "package.json") $InstallDir
    if (Test-Path (Join-Path $RepoDir "CLAUDE.md")) {
        Copy-Item -Force (Join-Path $RepoDir "CLAUDE.md") $InstallDir
    }
    Write-Host "Installed from local repo: $RepoDir" -ForegroundColor Green
} else {
    # 从 GitHub 下载安装
    Write-Host "Downloading from GitHub..." -ForegroundColor Yellow
    $TmpDir = Join-Path $env:TEMP "ix-ideal-install"
    $ZipPath = Join-Path $env:TEMP "ix-ideal.zip"

    Invoke-WebRequest -Uri "https://github.com/ienning/ix-ideal/archive/refs/heads/main.zip" -OutFile $ZipPath
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force

    $ExtractedDir = Get-ChildItem $TmpDir | Select-Object -First 1 -ExpandProperty FullName
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Recurse -Force (Join-Path $ExtractedDir "skills") $InstallDir
    Copy-Item -Force (Join-Path $ExtractedDir "package.json") $InstallDir

    Remove-Item -Recurse -Force $TmpDir, $ZipPath
    Write-Host "Downloaded and installed from GitHub" -ForegroundColor Green
}

Write-Host ""
Write-Host "OK $PluginName installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage in Claude Code:"
Write-Host "  /idea              - Start from scratch (AI guides you)"
Write-Host "  /idea my-idea.md   - Analyze existing template"
Write-Host ""
Write-Host "To uninstall: Remove-Item -Recurse -Force '$InstallDir'"
