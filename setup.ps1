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

            $wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Path 

            if ($wingetPath) {
                Write-Host "winget installed successfully." -ForegroundColor Green
            } else {
                Write-Warning "Failed to install winget. Update through the MS Store."
                exit 1
            }
        } catch {
            Write-Host "An error occurred while trying to install winget: $_" -ForegroundColor Red
            exit 1
        }
    }
}

function Get-Sys-Info {
    Write-Host "===== System Information =====" -ForegroundColor DarkGreen
    $serial = (Get-WmiObject -Class Win32_BIOS).serialnumber
    if ($serial) {
        Write-Host $("-" * 50)
        Write-Host "Serial Number: $serial" -ForegroundColor Cyan 
        Write-Host $("-" * 50)
    }

    else {
        Write-Host "Failed to retrieve the serial number." -ForegroundColor Red
    }

    Write-Host "BIOS Information" -ForegroundColor Cyan
    Get-CimInstance -ClassName Win32_BIOS
    Write-Host $("-" * 50)

    Write-Host "System Information" -ForegroundColor Cyan
    Get-CimInstance -ClassName Win32_ComputerSystem | Format-Table -Property Name, Domain, Model, Manufacturer -AutoSize -Wrap
    Write-Host $("-" * 50)

    Write-Host "Processor Information" -ForegroundColor Cyan
    Get-CimInstance -ClassName Win32_Processor | Format-Table -Property Name, Manufacturer -AutoSize -Wrap
    Write-Host $("-" * 50)
}

function Set-Tz {
    try {
        Write-Host "Setting Time Zone to Mountain Standard Time"
        Set-TimeZone -Id "Mountain Standard Time" -PassThru
        Write-Host "Time Zone set successfully." -ForegroundColor Green
        W32tm /resync /force
    }
    catch {
        Write-Warning "Failed to set the time zone: $_"
    }
}

function Install-Software {
    Write-Host "===== Uninstalling Software =====" -ForegroundColor DarkBlue

    # Uninstall McAfee
    Write-Host $("-" * 50)
    try {
        Write-Host "Uninstalling McAfee" -ForegroundColor Black -BackgroundColor Cyan
        winget uninstall McAfee.WPS -h  
        winget uninstall McAfeeWPSSparsePackage_0j6k21vdgrmfw -h 
        winget uninstall --id "{35ED3F83-4BDC-4c44-8EC6-6A8301C7413A}" -h 
        winget uninstall --id "MSC" -h 
        Write-Host "Unistalled: McAfee Products" -ForegroundColor DarkGreen
    }
    catch {
        Write-Warning "Failed"
        Write-Host "Failed to uninstall McAfee" -Foregroundcolor Red
    }

    Write-Host "===== Installing Software =====" -ForegroundColor DarkBlue

    # Install Chrome
    Write-Host $("-" * 50)
    try {
        Write-Host "Installing Google Chrome" -ForegroundColor Black -BackgroundColor Cyan
        winget install Google.Chrome -h --disable-interactivity --accept-package-agreements --accept-source-agreements
        Write-Host "Installed: Google Chrome" -ForegroundColor DarkGreen
    }
    catch {
        Write-Warning 'Failed'
        Write-Host 'Failed to install Google Chrome' -foregroundcolor Red
    }

    # Install Adobe Reader
    Write-Host $("-" * 50)
    try {
        Write-Host "Installing Adobe Reader" -ForegroundColor Black -BackgroundColor Cyan
        winget install Adobe.Acrobat.Reader.64-bit -h --accept-package-agreements --accept-source-agreements
        Write-Host "Installed: Adobe Reader" -ForegroundColor DarkGreen
    }
    catch {
        Write-Warning 'Failed'
        Write-Host 'Failed to install Adobe Reader' -Foregroundcolor Red
    }

    # Install Citrix
    Write-Host $("-" * 50)
    try {
        Write-Host install "Citrix Workspace" -ForegroundColor Black -BackgroundColor Cyan
        winget install XPFCG3278HX4X9 -h --accept-package-agreements --accept-source-agreements
        Write-Host "Installed: Citrix Workspace" -ForegroundColor DarkGreen
    }
    catch {
        Write-Warning 'Failed'
        Write-Host 'Failed to install Citrix Workspace' -foregroundcolor Red
    }

    # Install O365
    Write-Host $("-" * 50)
    try {
        Write-Host install "Installing Office 365" -ForegroundColor Black -BackgroundColor Cyan
        winget install 9WZDNCRD29V9 -h --accept-package-agreements --accept-source-agreements
        winget install Microsoft.Office -h --accept-package-agreements --disable-interactivity 
        winget install upgrade -h --accept-package-agreements --accept-source-agreements
        Write-Host "Installed: Office 365" -ForegroundColor DarkGreen
    }
    catch {
        Write-Warning 'Failed'
        Write-Host 'Failed to install Office 365' -foregroundcolor Red
    }
}

Install-Winget
Set-Tz
Get-Sys-Info
Install-Software
