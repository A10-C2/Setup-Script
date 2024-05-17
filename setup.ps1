# Automated Setup Script
$serial = wmic bios get serialnumber
Write-Host "Serial Number: $serial"

Get-TimeZone

# Uninstall McAfee
Write-Host "Uninstalling McAfee" -ForegroundColor Gray -BackgroundColor Blue
winget uninstall McAfee.WPS -h  
winget uninstall McAfeeWPSSparsePackage_0j6k21vdgrmfw -h 
winget uninstall --id "{35ED3F83-4BDC-4c44-8EC6-6A8301C7413A}" -h 
winget uninstall --id "MSC" -h 

# Install Chrome
Write-Host "Installing Google Chrome" -ForegroundColor Gray -BackgroundColor Blue
winget install Google.Chrome -h --disable-interactivity --accept-package-agreements --accept-source-agreements

# Install Reader
Write-Host "Installing Adobe Reader" -ForegroundColor Gray -BackgroundColor Blue
winget install Adobe.Acrobat.Reader.64-bit -h --accept-package-agreements --accept-source-agreements

# Install Citrix 
Write-Host install "Citrix Workspace" -ForegroundColor Gray -BackgroundColor Blue
winget install XPFCG3278HX4X9 -h --accept-package-agreements --accept-source-agreements

# Install O365 App & Office Suite
Write-Host install "Installing Office 365" -ForegroundColor Gray -BackgroundColor Blue
winget install 9WZDNCRD29V9 -h --accept-package-agreements --accept-source-agreements
winget install Microsoft.Office -h --accept-package-agreements --disable-interactivity 

# Upgrade all installed pkgs
winget install upgrade -h --accept-package-agreements --accept-source-agreements
Write-Host "Finished" -ForegroundColor Gray -BackgroundColor Blue
