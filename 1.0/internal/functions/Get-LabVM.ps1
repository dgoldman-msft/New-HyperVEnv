function Get-LabVM {
    <#
        .SYNOPSIS
            Get Virtual Machines

        .DESCRIPTION
            This function will retrieve all newly created VM's

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .EXAMPLE
            C:\PS> Get-LabVM

            Retrieve all vms and display them

        .NOTES
            Internal function
    #>

    [OutputType('New-HyperVEnv.VMS')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [string]
        $LabImageDirectory
    )

    process {
        try {
            foreach ($vm in Get-VM) {
                [PSCustomObject]@{
                    PSTypeName          = 'New-HyperVEnv.VMS'
                    'Virtual Machine'   = $vm.Name
                    Version             = $vm.Version
                    State               = $vm.State
                    Status              = $vm.Status
                    'AssignedMemory(M)' = $vm.MemoryAssigned
                    'VM Uptime'         = $vm.Uptime
                }
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
        }
    }
}