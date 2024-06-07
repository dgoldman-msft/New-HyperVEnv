function New-HyperVLab {
    <#
         .SYNOPSIS
             Install Hyper-V

         .DESCRIPTION
            This function will install Hyper-V on a Windows host

         .EXAMPLE
             C:\PS> New-HyperVEnv

             Check for Hyper-V and if not install then install it

         .NOTES
             Internal function
     #>

    [OutputType('System.Boolean')]
    [CmdletBinding(SupportsShouldProcess)]
    param()

    begin { Write-ToLogFile "$(Get-TimeStamp) Checking to see if Hyper-V is installed / enabled" -LabImageDirectory $LabImageDirectory -ErrorAction Stop}

    process {
        try {
            # Check if Hyper-V is installed, if not install it
            $hyperV = Get-WindowsOptionalFeature -FeatureName 'Microsoft-Hyper-V-All' -Online -ErrorAction Stop

            if ($hyperV.State -eq "Enabled") {
                Write-ToLogFile "$(Get-TimeStamp) Hyper-V is already installed and enabled" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                return $true
            }
            else {
                # Install Hyper-V
                Write-ToLogFile "$(Get-TimeStamp) Hyper-V is not installed or disabled. Installing / Enabling" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                if ($PSCmdlet.ShouldProcess("Hyper-V is not installed or disabled. Installing / Enabling")) {
                    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart -ErrorAction Stop
                    Write-ToLogFile "$(Get-TimeStamp) Hyper-V installed and enabled successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Restart-Computer
                    return $true
                }
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}