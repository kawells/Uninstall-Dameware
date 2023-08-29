# Uninstallation
$toUninstall = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "DameWare" } | Select-Object -Property DisplayName, UninstallString
foreach ($installedApp in $toUninstall) {
    $uninstallString = (($installedApp.UninstallString -split ' ')[1] -replace '/I','/X') + ' /qn /norestart'
    Start-process msiexec.exe -argumentlist $uninstallString -wait
}

# Uninstallation detection
$testPaths = "C:\Windows\dwrcs\DWRCS.exe","C:\Program Files\SolarWinds\Dameware Mini Remote Control\DWRCC.exe","C:\Program Files\SolarWinds\Dameware Mini Remote Control x64\DWRCC.exe"
$installed = $false
ForEach ($path in $testPaths) {
    If (Test-Path $path) {
        $installed = $true
    }
}
If ($installed) {
    # Still installed
}
Else {
    Write-Host "Uninstalled"
}
Exit $LASTEXITCODE