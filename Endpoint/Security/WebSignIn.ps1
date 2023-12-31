# Define the registry path, name, and value
$registryPath = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Authentication\EnableWebSignIn'
$registryName = 'value'
$registryValue = 1

# Error handling function
function Handle-Error {
    param (
        [string]$errorMessage
    )
    Write-Host "Error: $errorMessage" -ForegroundColor Red
    exit 1
}

# Attempt to set the registry key
try {
    # Check if the registry path exists
    if (-not (Test-Path $registryPath)) {
        Handle-Error "Registry path does not exist: $registryPath"
    }

    # Set the registry key
    Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue

    Write-Host "Registry key set successfully."
} catch {
    Handle-Error "An unexpected error occurred: $_"
}
