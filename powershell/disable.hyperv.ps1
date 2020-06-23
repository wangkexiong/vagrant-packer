
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V /Quiet

sleep 5
Write-Host "Hyperv is disabled..."
