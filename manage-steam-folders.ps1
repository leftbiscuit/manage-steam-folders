# manage-steam-folders.ps1
# Version 103
param(
    [string] $BackupSteamappsPath,
    [string] $BackupUserdataPath,
    [string] $RestoreSteamappsPath,
    [string] $RestoreUserdataPath,
    [switch] $GetHash,
    [switch] $DryRun
)

$steamRoot     = "C:\Program Files (x86)\Steam"
$origSteamapps = Join-Path $steamRoot "steamapps"
$origUserdata  = Join-Path $steamRoot "userdata"

function Get-FolderHash {
    param([string] $Path)
    if (-not (Test-Path $Path)) { return $null }

    $files = Get-ChildItem -Path $Path -Recurse -File | Sort-Object FullName
    $lines = foreach ($f in $files) {
        $rel  = $f.FullName.Substring($Path.Length).TrimStart('\')
        $hash = (Get-FileHash -Algorithm SHA256 -Path $f.FullName).Hash
        "$rel`:$hash"
    }
    $bytes  = [System.Text.Encoding]::UTF8.GetBytes($lines -join "`n")
    $sha    = [System.Security.Cryptography.SHA256]::Create()
    $digest = $sha.ComputeHash($bytes)

    return ($digest | ForEach-Object { $_.ToString("x2") }) -join ""
}

function Backup-Folder {
    param(
        [string] $OriginalPath,
        [string] $BackupDestPath
    )
    if (-not (Test-Path $OriginalPath)) {
        Write-Error "[ERROR] Original folder does not exist: $OriginalPath"
        return
    }
    $msg = if ($DryRun) { "[DRY-RUN] BACKUP: $OriginalPath -> $BackupDestPath" }
           else { "[BACKUP] $OriginalPath -> $BackupDestPath" }
    Write-Host $msg
    if (-not $DryRun) {
        Copy-Item -Path $OriginalPath -Destination $BackupDestPath -Recurse -Force
    }
}

function Restore-Folder {
    param(
        [string] $SourcePath,
        [string] $TargetRoot
    )
    $name   = [IO.Path]::GetFileName($SourcePath)
    $target = Join-Path $TargetRoot $name

    if ($DryRun) {
        Write-Host "[DRY-RUN] RESTORE: $SourcePath -> $target"
        return
    }

    if (-not (Test-Path $SourcePath)) {
        Write-Error "[ERROR] No source to restore: $SourcePath"
        return
    }

    Write-Host "[RESTORE] $SourcePath -> $target"
    Copy-Item -Path $SourcePath -Destination $TargetRoot -Recurse -Force
}

if ($GetHash) {
    Write-Host "`n=== Hash BEFORE ==="
    Write-Host "steamapps: $(Get-FolderHash -Path $origSteamapps)"
    Write-Host "userdata : $(Get-FolderHash -Path $origUserdata)`n"
}

if ($BackupSteamappsPath) {
    Backup-Folder -OriginalPath $origSteamapps -BackupDestPath $BackupSteamappsPath
}

if (Test-Path $origSteamapps) {
    $msg = if ($DryRun) { "[DRY-RUN] REMOVE: $origSteamapps" }
           else        { "[REMOVE] $origSteamapps" }
    Write-Host $msg
    if (-not $DryRun) {
        Remove-Item -LiteralPath $origSteamapps -Recurse -Force
    }
}

if ($RestoreSteamappsPath) {
    Restore-Folder -SourcePath $RestoreSteamappsPath -TargetRoot $steamRoot
}

if ($BackupUserdataPath) {
    Backup-Folder -OriginalPath $origUserdata -BackupDestPath $BackupUserdataPath
}

if (Test-Path $origUserdata) {
    $msg = if ($DryRun) { "[DRY-RUN] REMOVE: $origUserdata" }
           else { "[REMOVE] $origUserdata" }
    Write-Host $msg
    if (-not $DryRun) {
        Remove-Item -LiteralPath $origUserdata -Recurse -Force
    }
} else {
    Write-Warning "Folder userdata does not exist, skipping removal."
}

if ($RestoreUserdataPath) {
    Restore-Folder -SourcePath $RestoreUserdataPath -TargetRoot $steamRoot
}

if ($GetHash) {
    Write-Host "`n=== Hash AFTER ==="
    Write-Host "steamapps: $(Get-FolderHash -Path $origSteamapps)"
    Write-Host "userdata : $(Get-FolderHash -Path $origUserdata)"
}