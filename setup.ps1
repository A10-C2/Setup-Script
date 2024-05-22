# Automated Setup Script

# Get Serial Number
$serial = (Get-WmiObject -Class Win32_BIOS).serialnumber
Write-Host "Serial Number: $serial"

# Check if successful
if ($serial) {
    Write-Host "Serial number retrieved successfully."
} else {
    Write-Host "Failed to retrieve the serial number." -ForegroundColor Red
}

# Setting time zone
try {
    Write-Host "Setting Time Zone to Mountain Standard Time"
    Set-TimeZone -Id "Mountain Standard Time" -PassThru
    Write-Host "Time Zone set successfully."
} catch {
    Write-Host "Failed to set the time zone: $_" -ForegroundColor Red
}

# Get Bios Information
Get-CimInstance -ClassName Win32_BIOS

# Get System Information
Get-CimInstance -ClassName Win32_ComputerSystem | Format-Table -Property Name, Domain, Model, Manufacturer -AutoSize -Wrap

# Get Processor Information
Get-CimInstance -ClassName Win32_Processor | Format-Table -Property Name, Manufacturer -AutoSize -Wrap

# Uninstall McAfee
Write-Host "Uninstalling McAfee" -ForegroundColor Black -BackgroundColor Cyan
winget uninstall McAfee.WPS -h  
winget uninstall McAfeeWPSSparsePackage_0j6k21vdgrmfw -h 
winget uninstall --id "{35ED3F83-4BDC-4c44-8EC6-6A8301C7413A}" -h 
winget uninstall --id "MSC" -h 

# Install Chrome
Write-Host "Installing Google Chrome" -ForegroundColor Black -BackgroundColor Cyan
winget install Google.Chrome -h --disable-interactivity --accept-package-agreements --accept-source-agreements

# Install Reader
Write-Host "Installing Adobe Reader" -ForegroundColor Black -BackgroundColor Cyan
winget install Adobe.Acrobat.Reader.64-bit -h --accept-package-agreements --accept-source-agreements

# Install Citrix 
Write-Host install "Citrix Workspace" -ForegroundColor Black -BackgroundColor Cyan
winget install XPFCG3278HX4X9 -h --accept-package-agreements --accept-source-agreements

# Install O365 App & Office Suite
Write-Host install "Installing Office 365" -ForegroundColor Black -BackgroundColor Cyan
winget install 9WZDNCRD29V9 -h --accept-package-agreements --accept-source-agreements
winget install Microsoft.Office -h --accept-package-agreements --disable-interactivity 

# Upgrade all installed pkgs
winget install upgrade -h --accept-package-agreements --accept-source-agreements
Write-Host "Finished" -ForegroundColor Gray -BackgroundColor Blue
