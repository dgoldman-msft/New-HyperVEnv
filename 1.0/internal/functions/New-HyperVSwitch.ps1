function New-HyperVSwitch {
    <#
          .SYNOPSIS
              Create a Hyper V Switch

          .DESCRIPTION
              This function will create a new Hyper-V Switch

          .PARAMETER SwitchName
              Default Hyper-V Lab Switch Name

          .EXAMPLE
              C:\PS> New-HyperVSwitch -SwitchName $SwitchName

              Create a new default Hyper-V Switch

          .NOTES
              Internal function
      #>

    [OutputType('System.Boolean')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]
        $SwitchName
    )

    begin { Write-ToLogFile "$(Get-TimeStamp) Checking for default Hyper-V Switch" -LabImageDirectory $LabImageDirectory -ErrorAction Stop }

    process {
        try {
            $switch = Get-VMSwitch -ErrorAction Stop
            if (-NOT($switch -match "Hyper-VSwitch")) {
                # Create a Hyper-V switch

                if ($PSCmdlet.ShouldProcess("Creating a Hyper-V switch")) {
                    $newSwitch = New-VMSwitch -Name $SwitchName -SwitchType Internal

                    if ($newSwitch.Name) {
                        Write-ToLogFile "$(Get-TimeStamp) $($switchName) created successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop

                        # Configure the IP address for the Hyper-V switch
                        Write-ToLogFile "$(Get-TimeStamp) Configuring the IP address for the Hyper-V switch" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        $ifIndex = (Get-NetAdapter | Where-Object { $_.Name -match $SwitchName }).ifIndex
                        New-NetIPAddress -IPAddress 192.168.1.1 -PrefixLength 24 -InterfaceIndex $ifIndex -ErrorAction Stop
                        Write-ToLogFile "$(Get-TimeStamp) New Net IP Address configured successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        New-NetNAT -Name "NAT-Network" -InternalIPInterfaceAddressPrefix 192.168.1.0/24 -ErrorAction Stop
                        Write-ToLogFile "$(Get-TimeStamp) New Net Nat configured successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        return $true
                    }
                    else {
                        Write-ToLogFile "$(Get-TimeStamp) Failed to create Hyper-V switch" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        return $false
                    }
                }
            }
            else {
                Write-ToLogFile "$(Get-TimeStamp) Default $($SwitchName) already exists!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}
