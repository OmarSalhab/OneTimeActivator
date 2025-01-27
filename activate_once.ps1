# Wrapper script to limit execution to once
$markerFile = "$env:USERPROFILE\.activation_marker"

if (Test-Path $markerFile) {
    Write-Host "This command has already been used once and cannot be executed again." -ForegroundColor Red
    exit
}

# Execute the original command
try {
    irm https://get.activated.win | iex
    # If successful, create the marker file
    New-Item -Path $markerFile -ItemType File -Force | Out-Null
    Write-Host "Command executed successfully. It will not run again." -ForegroundColor Green
} catch {
    Write-Host "An error occurred while executing the command." -ForegroundColor Red
}
