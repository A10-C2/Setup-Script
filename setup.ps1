# Automated Setup Script

# Check if winget is installed
function Install-Winget {
    Write-Host "Checking if winget is installed..."
    $wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Path

    if ($wingetPath) {
        Write-Host "winget is already installed" -ForegroundColor Green
    } else {
        Write-Warning "winget is not installed. Installing winget..."

        try {
            $appInstallerUri = "https://aka.ms/getwinget"
            $appInstallerPath = "$env:TEMP\AppInstaller.appxbundle"
            Invoke-WebRequest -Uri $appInstallerUri -OutFile $appInstallerPath
            Add-AppxPackage -Path $appInstallerPath
            
            # Verify Install
            $wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Path 

        if ($wingetPath) {
            Write-Host "winget installed successfully." -ForegroundColor Green
        } else {
            Write-Warning "Failed to install winget. Update throught the MS Store."
            exit 1
        }
    } catch {
        Write-Host "An error occurred while trying to install winget: $_" -ForegroundColor Red
        exit 1
    }
    }
}

Install-Winget

# Get Serial Number
$serial = (Get-WmiObject -Class Win32_BIOS).serialnumber
if ($serial) {
    Write-Host "Serial Number: $serial" -ForegroundColor Cyan -BackgroundColor Black
} else {
    Write-Host "Failed to retrieve the serial number." -ForegroundColor Red
}

# Setting time zone
try {
    Write-Host "Setting Time Zone to Mountain Standard Time"
    Set-TimeZone -Id "Mountain Standard Time" -PassThru
    Write-Host "Time Zone set successfully." -ForegroundColor Cyan
} catch {
    Write-Warning "Failed to set the time zone: $_"
}

# Get Bios Information
Write-Host "BIOS Information" -ForegroundColor Cyan
Get-CimInstance -ClassName Win32_BIOS
Write-Host "--------------------------------------" -ForegroundColor Green

# Get System Information
Write-Host "System Information" -ForegroundColor Cyan
Get-CimInstance -ClassName Win32_ComputerSystem | Format-Table -Property Name, Domain, Model, Manufacturer -AutoSize -Wrap
Write-Host "--------------------------------------" -ForegroundColor Green

# Get Processor Information
Write-Host "Processor Information" -ForegroundColor Cyan
Get-CimInstance -ClassName Win32_Processor | Format-Table -Property Name, Manufacturer -AutoSize -Wrap
Write-Host "--------------------------------------" -ForegroundColor Green

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
Write-Host "Finished" -ForegroundColor Green
