function New-KaliVM {
    <#
        .SYNOPSIS
            Install Kali Linux

        .DESCRIPTION
            This function will download and build a Kali Linux VM

        .PARAMETER DefaultProcessorCount
            Set the default MV processor count

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .PARAMETER Memory
            The memory to be allocated to the VMs. Defaults to 4GB if not specified.

        .PARAMETER SwitchName
            Default Hyper-V Lab Switch Name

        .EXAMPLE
            C:\PS> New-KaliVM

            Download kali Linux and build our a VM

        .NOTES
            Internal function
    #>

    [OutputType('System.Boolean')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Int]
        $DefaultProcessorCount,

        [string]
        $LabImageDirectory,

        [Int64]
        $Memory,

        [string]
        $SwitchName
    )

    begin {
        Write-ToLogFile "$(Get-TimeStamp) Creating Kali Linux VM" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
        $kaliVMName = "Kali Linux 2024.1"
    }

    process {
        try {
            # Create a Kali Linux VM
            if ($PSCmdlet.ShouldProcess("Creating Kali Linux hyper-v")) {
                $kaliVM = New-VM -Name $kaliVMName -Generation 2 -MemoryStartupBytes $Memory -SwitchName 'Hyper-VSwitch'
                # -VHDPath "$LabImageDirectory\KaliImages\$kaliImageDir\$kaliVHDX"

                if ($kaliVM) {
                    Write-ToLogFile "$(Get-TimeStamp) $($kaliVMName) created! Setting additional VM parameters" -LabImageDirectory $LabImageDirectory -ErrorAction Stop

                    # Set VM Optional Settings
                    Set-VM -Name $kaliVMName -Notes "Penetration Testing System"
                    Write-ToLogFile "$(Get-TimeStamp) Setting notes for $($kaliVM)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Set-VMFirmware -VMName $kaliVMName -EnableSecureBoot Off
                    Write-ToLogFile "$(Get-TimeStamp) Set VM Firmware for $($kaliVMName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Set-VMProcessor -VMName $kaliVMName -Count $DefaultProcessorCount
                    Write-ToLogFile "$(Get-TimeStamp) Set Default process count for $($kaliVMName) to $($DefaultProcessorCount)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Add-VMNetworkAdapter -VMName $kaliVMName -Name 'Hyper-VSwitch'
                    Write-ToLogFile "$(Get-TimeStamp) Binding networking adapter for $($kaliVMName) to $($SwitchName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Set-VM -Name $kaliVMName -EnhancedSessionTransportType HVSocket
                    Write-ToLogFile "$(Get-TimeStamp) Enabled Enhanced Session Transport Type for $($kaliVMName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    Set-VMhost -Name $kaliVMName -EnableEnhancedSessionMode $True -ErrorAction SilentlyContinue
                    Write-ToLogFile "$(Get-TimeStamp) Enabled Enhanced Session Mode for $($kaliVMName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop

                    # Set up the Kali Linux VM (additional configuration steps go here)
                    # ...
                    Write-ToLogFile "$(Get-TimeStamp) Default User: kali & Default Password: kali" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    return $true
                }
                else {
                    Write-ToLogFile "$(Get-TimeStamp) $($kaliVMName) failed to create!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    return $false
                }
            }
        }
        catch {
            Write-Output "Error detected: $_"
            return $false
        }
    }
}