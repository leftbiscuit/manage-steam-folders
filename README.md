# manage-steam-folders.ps1 Manual

**Version:** 103  
**Date:** 13 July 2025

---

## SYNOPSIS

```powershell
manage-steam-folders.ps1
    [-BackupSteamappsPath <string>]
    [-BackupUserdataPath <string>]
    [-RestoreSteamappsPath <string>]
    [-RestoreUserdataPath <string>]
    [-GetHash]
    [-DryRun]
```

---

## DESCRIPTION

This PowerShell script automates management of a Steam installation’s `steamapps` and `userdata` directories. It can:

- **Back up** existing folders to specified destinations.
- **Restore** folders from backups into the Steam root.
- **Compute SHA-256 hashes** of both folders before and after operations to verify integrity.
- **Perform a dry-run** to preview actions without modifying any files.

---

## OPTIONS

| Option                      | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `-BackupSteamappsPath`      | Path where the `steamapps` folder will be backed up.                        |
| `-BackupUserdataPath`       | Path where the `userdata` folder will be backed up.                         |
| `-RestoreSteamappsPath`     | Source path from which to restore the `steamapps` folder into the Steam root.|
| `-RestoreUserdataPath`      | Source path from which to restore the `userdata` folder into the Steam root. |
| `-GetHash`                  | Compute and display SHA-256 hashes of both `steamapps` and `userdata` before and after backup/restore operations. |
| `-DryRun`                   | Perform a trial run, outputting planned actions without making any changes.  |

---

## EXAMPLES

**1. Preview backup and restore of `steamapps` (dry-run):**

```powershell
.\manage-steam-folders.ps1 -BackupSteamappsPath "D:\Bak\steamapps" -RestoreSteamappsPath "D:\Bak\steamapps" -GetHash -DryRun
```

**2. Back up and restore both `steamapps` and `userdata`:**

```powershell
.\manage-steam-folders.ps1 -BackupSteamappsPath "D:\Bak\steamapps" -BackupUserdataPath "D:\Bak\userdata" -RestoreSteamappsPath "D:\Bak\steamapps" -RestoreUserdataPath "D:\Bak\userdata"
```

---

## SEE ALSO

- [`Get-FileHash`](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/get-filehash)
- [`Copy-Item`](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/copy-item)
- [`Remove-Item`](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/remove-item)
- [`Test-Path`](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/test-path)
- [`Write-Host`](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/write-host)
- [`Write-Error`](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/write-error)
- [`Write-Warning`](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/write-warning)