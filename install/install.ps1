# IXIdeal Install Script for Windows
# Claude Code 只识别 ~/.claude/skills/<name>/SKILL.md 形式的用户级 skill
$SkillName = "idea"
$InstallDir = Join-Path $env:USERPROFILE ".claude\skills\$SkillName"
$LegacyDir = Join-Path $env:USERPROFILE ".claude\plugins\ix-ideal"

Write-Host "Installing skill '$SkillName' to $InstallDir..." -ForegroundColor Cyan

# 通过 irm | iex 执行时没有脚本路径，直接走 GitHub 下载
$ScriptPath = $MyInvocation.MyCommand.Path
$RepoDir = if ($ScriptPath) { Split-Path -Parent (Split-Path -Parent $ScriptPath) } else { $null }

# 检测安装方式（本地 vs GitHub）
if ($RepoDir -and (Test-Path (Join-Path $RepoDir ".git"))) {
    # 从本地仓库安装
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Recurse -Force (Join-Path $RepoDir "skills\$SkillName\*") $InstallDir
    Write-Host "Installed from local repo: $RepoDir" -ForegroundColor Green
} else {
    # 从 GitHub 下载安装
    Write-Host "Downloading from GitHub..." -ForegroundColor Yellow
    $TmpDir = Join-Path $env:TEMP "ix-ideal-install"
    $ZipPath = Join-Path $env:TEMP "ix-ideal.zip"

    Invoke-WebRequest -Uri "https://github.com/ienning/IXIdeal/archive/refs/heads/main.zip" -OutFile $ZipPath
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force

    $ExtractedDir = Get-ChildItem $TmpDir | Select-Object -First 1 -ExpandProperty FullName
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Recurse -Force (Join-Path $ExtractedDir "skills\$SkillName\*") $InstallDir

    Remove-Item -Recurse -Force $TmpDir, $ZipPath
    Write-Host "Downloaded and installed from GitHub" -ForegroundColor Green
}

# 清理旧版脚本装到 plugins 目录下的残留（该位置不会被 Claude Code 加载）
if (Test-Path $LegacyDir) {
    Remove-Item -Recurse -Force $LegacyDir
    Write-Host "Removed legacy install: $LegacyDir" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "OK skill '$SkillName' installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage in Claude Code (restart Claude Code first):"
Write-Host "  /idea              - Start from scratch (AI guides you)"
Write-Host "  /idea my-idea.md   - Analyze existing template"
Write-Host ""
Write-Host "To uninstall: Remove-Item -Recurse -Force '$InstallDir'"
