# Define the unique key for this command (you should generate a new key for each customer)
$key = "UNIQUE-CUSTOMER-KEY-4"

# Define the server-side endpoint that checks and tracks key usage
$validationUrl = "https://key-validation-backend.onrender.com"

# Check if the key has already been used
$response = Invoke-WebRequest -Uri "$validationUrl?key=$key" -UseBasicParsing -Method GET
if ($response.Content -eq "invalid") {
    Write-Host "This command has already been used and cannot be executed again." -ForegroundColor Red
    exit
}

# Local marker to prevent multiple executions on the same machine
$markerFile = "$env:USERPROFILE\.activation_marker_$key"

if (Test-Path $markerFile) {
    Write-Host "This command has already been used on this machine and cannot be executed again." -ForegroundColor Red
    exit
}

# Execute the original command
try {
    irm https://get.activated.win | iex

    # If successful, mark the key as used locally and remotely
    New-Item -Path $markerFile -ItemType File -Force | Out-Null

    # Notify the server that the key was used successfully
    Invoke-WebRequest -Uri "$validationUrl?key=$key" -Method POST

    Write-Host "Command executed successfully. It will not run again." -ForegroundColor Green
} catch {
    Write-Host "An error occurred while executing the command." -ForegroundColor Red
}
