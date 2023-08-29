# Uninstall-Dameware
MECM/SCCM-compatible script that will uninstall all DameWare-related applications. Uninstall detection method included.

Deployment command: `powershell.exe -executionpolicy Bypass -Command "& { & '.\Remove-Dameware.ps1'; Exit $LastExitCode }"`
