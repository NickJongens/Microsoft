# ------------ MEM VARIABLES ----------------
[CmdletBinding()]
param
(
    [Parameter()]
    [String] $PrinterPortIPAddress = "IP ADDRESS",
    [Parameter()]
    [String] $PrinterPortName = "Intune Deployed - COMPANY - IP ADDRESS",
    [Parameter()]
    [String] $PrinterName = "NAME ON CONTROL PANEL",
    [Parameter()]
    [String] $PrinterDriverModelName = "NAME OF THE DRIVER IN PRINT MANAGEMENT"
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


try
{
    $Printer = Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue
    if ($Printer)
    {
        if ($Printer.DriverName -eq $PrinterDriverModelName)
        {
            $PrinterPort = Get-PrinterPort -Name $($Printer.PortName) -ErrorAction SilentlyContinue
            if ($PrinterPort)
            {
                if ($PrinterPort.PrinterHostAddress -eq $PrinterPortIPAddress)
                {
                    # All checks pass
                    Update-OutputOnExit -F_ExitCode $ExitWithNoError -F_Message "SUCCESS"
                }
                else
                {
                    # Wrong IP Address
                    Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
                }
            }
            else
            {
                # Wrong Port
                Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
            }
        }
        else
        {
            # Wrong Driver
            Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
        }
    }
    else
    {
        # No Printer
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
catch
{
    Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
}