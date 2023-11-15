

# ------------ MEM VARIABLES ----------------
[CmdletBinding()]
param
(
    [Parameter()]
    [String] $PrinterPortIPAddress = "IP ADDRESS",
    [Parameter()]
    [String] $PrinterPortName = "Intune Deployed - COMPANY - IP ADDRESS",
    [Parameter()]
    [String] $PrinterName = "NAME IN CONTROL PANEL",
    [Parameter()]
    [String] $PrinterDriverModelName = "NAME OF THE DRIVER IN PRINT MANAGEMENT",
    [Parameter()]
    [String] $PrinterDriverZipFileName = "DRIVER_COMPANY_BRAND_MODEL_SUBMODEL.zip",
    [Parameter()]
    [String] $PrinterDriverModelFileName = "INF FILE INSIDE DRIVER.ZIP"
)

[bool] $ExitWithError = $true
[bool] $ExitWithNoError = $false

function Update-OutputOnExit
{
    param
    (
        [bool] $F_ExitCode,
        [String] $F_Message
    )
    
    Write-Host "STATUS=$F_Message" -ErrorAction SilentlyContinue

    if ($F_ExitCode)
    {
        exit 1
    }
    else
    {
        exit 0
    }
}


function Test-PrinterPortExists
{
    # IP Address of the Printer
    param
    (
        [String] $PrinterFPortName
    )
    

    if (Get-PrinterPort | Where-Object {$_.Name -like "*$($PrinterFPortName)*"})
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Test-PrinterExists
{
    # Name of the Printer
    param
    (
        [String] $PrinterFName
    )    

    if (Get-Printer -Name $PrinterFName -ErrorAction SilentlyContinue)
    {
        return $true
    }
    else
    {
        return $false
    }
}

# Installing the Driver
Expand-Archive -Path "$PSScriptRoot\$PrinterDriverZipFileName" -DestinationPath "$PSScriptRoot\" -Force
If (Test-Path -Path "$PSScriptRoot\Driver")
{
    try
    {
        cscript "C:\Windows\System32\Printing_Admin_Scripts\en-US\prndrvr.vbs" -a -m $PrinterDriverModelName -i "$PSScriptRoot\Driver\$PrinterDriverModelFileName" -h "$PSScriptRoot\Driver" -v 3
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
    
}
else
{
    Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
}


# Installing the Printer Port
if (!(Test-PrinterPortExists -PrinterFPortName $PrinterPortName))
{
    try
    {
        Add-PrinterPort -Name $PrinterPortName -PrinterHostAddress $PrinterPortIPAddress -PortNumber 9100
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
else
{
    write-host "$PrinterPortName aleady exists in the system!"
}

# Installing the Printer
if (!(Test-PrinterExists -PrinterFName $PrinterName))
{
    try
    {
        Add-Printer -Name $PrinterName -PortName $PrinterPortName -DriverName $PrinterDriverModelName
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
else
{
    write-host "$PrinterName aleady exists in the system!"
}

Update-OutputOnExit -F_ExitCode $ExitWithNoError -F_Message "SUCCESS"