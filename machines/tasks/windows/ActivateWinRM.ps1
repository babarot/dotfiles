# PowerShell script to configure WinRM for Ansible

# Function to configure WinRM
function Configure-WinRM {
    # Enable WinRM service
    Write-Host "Enabling WinRM service..."
    winrm quickconfig -force

    # Allow Basic authentication
    Write-Host "Setting Basic authentication..."
    winrm set winrm/config/service/auth '@{Basic="true"}'

    # Allow unencrypted traffic
    Write-Host "Allowing unencrypted traffic..."
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'

    # Increase memory per shell
    Write-Host "Increasing MaxMemoryPerShellMB..."
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'

    # Create WinRM listener for HTTP if not exists
    Write-Host "Creating WinRM listener for HTTP..."
    $listener = winrm enumerate winrm/config/listener | where { $_ -match "Listener\[.*\] Transport = HTTP" }
    if (-not $listener) {
        winrm create winrm/config/listener?Address=*+Transport=HTTP
    } else {
        Write-Host "WinRM listener for HTTP already exists."
    }

    # Set firewall rule to allow WinRM
    Write-Host "Setting firewall rule to allow WinRM..."
    New-NetFirewallRule -Name "Ansible-WinRM-HTTP" -DisplayName "Ansible WinRM over HTTP" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

    # Enable CredSSP authentication
    Write-Host "Enabling CredSSP authentication..."
    Enable-WSManCredSSP -Role Server -Force

    Write-Host "WinRM configuration complete."
}

# Function to add the current user to the local administrators group (optional, if needed)
function Add-UserToLocalAdmins {
    param (
        [string]$username
    )

    Write-Host "Adding $username to local administrators group..."
    Add-LocalGroupMember -Group "Administrators" -Member $username
}

# Main script execution
try {
    # Get the current username
    $currentUsername = "$env:USERDOMAIN\$env:USERNAME"

    # Configure WinRM
    Configure-WinRM

    # Optionally add the current user to local administrators group
    # Uncomment the following line if needed
    # Add-UserToLocalAdmins -username $currentUsername

    Write-Host "WinRM setup script completed successfully."
} catch {
    Write-Host "An error occurred: $_"
}

