# Deployment command: powershell.exe -executionpolicy Bypass -Command "& { & '.\Remove-Dameware.ps1'; Exit $LastExitCode }"
$damewarePath = "C:\Windows\dwrcs\"

# Stop Service
$serviceList = Get-Service |  Where-Object {$_.DisplayName -Match "DameWare"}
if ($serviceList.Count -ne 0 ){
    $serviceList | Set-Service -Status Stopped -ErrorAction Ignore
}

# Uninstallation
$toUninstall = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "DameWare" } | Select-Object -Property DisplayName, UninstallString
foreach ($installedApp in $toUninstall) {
    $uninstallString = (($installedApp.UninstallString -split ' ')[1] -replace '/I','/X') + ' /qn /norestart'
    Start-process msiexec.exe -argumentlist $uninstallString -wait
}

# Uninstallation detection
Function Test-DamewarePaths {
    $testPaths = "C:\Windows\dwrcs\DWRCS.exe","C:\Program Files\SolarWinds\Dameware Mini Remote Control\DWRCC.exe","C:\Program Files\SolarWinds\Dameware Mini Remote Control x64\DWRCC.exe"
    ForEach ($path in $testPaths) {
        If (Test-Path $path) { Return $true }
        Else { Return $false }
    }
}

# Manual removal
If (Test-DamewarePaths) {
    # Still installed, manual removal
    $preRemovalService = Get-Service | Where-Object {$_.DisplayName -Match "DameWare"}
    sc.exe delete $preRemovalService.Name
    $postRemovalService = Get-Service | Where-Object {$_.DisplayName -Match "DameWare"}
    # Service removal success
    If ($postRemovalService.Count -eq 0) {
        # If files still exist, remove them
        If (Test-Path $damewarePath) {
            Remove-Item $damewarePath -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
    Else {
        # Service removal failure
    }
}

# Final detection
If (Test-DamewarePaths) {

}
Else {
    Write-Host "Uninstalled"
}

Exit $LASTEXITCODE
