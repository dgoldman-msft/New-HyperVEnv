function New-WinVM {
    <#
        .SYNOPSIS
            Create Windows VM

        .DESCRIPTION
            This function will create three Windows VM's

        .PARAMETER DefaultProcessorCount
            Set the default MV processor count

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .PARAMETER Memory
            The memory to be allocated to the VMs. Defaults to 4GB if not specified.

        .PARAMETER SwitchName
            Default Hyper-V Lab Switch Name

        .EXAMPLE
            C:\PS> New-WinVM

            Create three Windows VM's WinDC,  WinServer and Win11Client

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

    begin {  Write-ToLogFile "$(Get-TimeStamp) Creating Windows VM's" -LabImageDirectory $LabImageDirectory -ErrorAction Stop }

    process {
        try {
            # Create 3 Hyper-V machines
            $vmNames = "WinDC", "WinServer", "Win11Client"
            foreach ($vm in $vmNames) {
                if ($PSCmdlet.ShouldProcess("Creating Hyper-V machines")) {
                    $createdVm = New-VM -Name $vm -Generation 2 -MemoryStartupBytes $Memory -SwitchName 'Hyper-VSwitch'

                    if ($createdVm) {
                        # Set VM Optional Settings
                        Write-ToLogFile "$(Get-TimeStamp) $($vm) created!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Set-VM -Name $vm -Notes "Windows Penetration Testing System"
                        Write-ToLogFile "$(Get-TimeStamp) Setting notes for $($vm)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Add-VMNetworkAdapter -VMName $($vm) -Name 'Hyper-VSwitch'
                        Write-ToLogFile "$(Get-TimeStamp) Binding networking adapter for $($vm) to $($SwitchName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Set-VMProcessor -VMName $vm -Count $DefaultProcessorCount
                        Write-ToLogFile "$(Get-TimeStamp) Set Default process count for $($vm) to $($DefaultProcessorCount)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Set-VM -Name $vm -EnhancedSessionTransportType HVSocket
                        Write-ToLogFile "$(Get-TimeStamp) Enabled Enhanced Session Transport Type for $($vm)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Enable-VMIntegrationService -VMName $vm -Name "Guest Service Interface"
                        Write-ToLogFile "$(Get-TimeStamp) Enabled VM Integration Service for Guest Services" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        Set-VMhost -ComputerName $($vm) -EnableEnhancedSessionMode $True -ErrorAction SilentlyContinue
                        Write-ToLogFile "$(Get-TimeStamp) Enabled Enhanced Session Mode for $($vm)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    }
                    else {
                        Write-ToLogFile "$(Get-TimeStamp) Failed to create $($vm)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                        continue
                    }
                }
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}