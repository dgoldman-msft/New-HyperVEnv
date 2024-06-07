function New-HyperVEnv {
    <#
    .SYNOPSIS
        A function to create a Hyper-V environment with 3 VMs.

    .DESCRIPTION
        This function creates a Hyper-V switch and 3 Hyper-V VMs. It also configures the IP addresses for the Hyper-V switch and the VMs.

    .PARAMETER LabImageDirectory
        Directory to store / install lab images.

    .PARAMETER DefaultProcessorCount
        Set the default MV processor count

    .PARAMETER DownloadKali
        Download a Kali Linux image. Default is false

    .PARAMETER ImageType
        Select image type you want to create (Windows, Kali or both)

    .PARAMETER Memory
        The memory to be allocated to the VMs. Defaults to 4GB if not specified.

    .PARAMETER SwitchName
        Default Hyper-V Lab Switch Name

    .EXAMPLE
        NewEnv -All

        This will create a new environment using the alias 'NewEnv' and create 3 Windows machines and 1 kali linux machine with 4gb of ram and 2 processors (Default is 2)

    .EXAMPLE
        New-HyperVEnv -LabImageDirectory "C:\<Your Directory Name>\vhdfile.vhd" -Memory 4096 -DefaultProcessorCount 4

        This will create a new environment in a directory you specify instead of the default for 3 Windows machines and 1 kali linux machine with 4gb of ram and 4 processors (Default is 2)

    .EXAMPLE
        New-HyperVEnv -ImageType Kali

        This will create a new environment for 1 kali linux machine with the default settings
    #>

    [Alias('NewEnv')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Int]
        $DefaultProcessorCount = 2,

        [switch]
        $DownloadKali,

        [ValidateSet('Kali', 'Windows', 'All')]
        [string]
        $ImageType = 'All',

        [string]
        $LabImageDirectory = "C:\LabImages",

        [ValidateSet('2GB', '4GB', '8GB')]
        [Int64]
        $Memory = 4GB,

        [string]
        $SwitchName = "Hyper-VSwitch"
    )

    begin {
        New-FolderStructure -LabImageDirectory $LabImageDirectory
        Write-ToLogFile "$(Get-TimeStamp) Starting process" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
    }

    process {
        # Download Kali Linux VHDX
        try {
            if (Install-7Zip) {
                if ($DownloadKali) {
                    Get-Kali -LabImageDirectory $LabImageDirectory
                    Write-ToLogFile "$(Get-TimeStamp) Kali Linux image downloading in the background" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                }
                else {
                    Write-ToLogFile "$(Get-TimeStamp) User specified not to download Kali Linux image" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                }

                if (New-HyperVLab) {
                    if (New-HyperVSwitch -SwitchName $switchName) {
                        switch ($ImageType) {
                            'All' {
                                Write-ToLogFile "$(Get-TimeStamp) Creating Windows and Kali Virtual Machines" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                                New-WinVm -LabImageDirectory $LabImageDirectory -DefaultProcessorCount $DefaultProcessorCount -Memory $Memory -SwitchName $switchName
                                New-KaliVm -LabImageDirectory $LabImageDirectory -DefaultProcessorCount $DefaultProcessorCount -Memory $Memory -SwitchName $switchName
                            }
                            'Windows' {
                                Write-ToLogFile "$(Get-TimeStamp) Creating Windows Virtual Machines" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                                New-WinVm -LabImageDirectory $LabImageDirectory -DefaultProcessorCount $DefaultProcessorCount -Memory $Memory -SwitchName $switchName
                            }
                            'Kali' {
                                Write-ToLogFile "$(Get-TimeStamp) Creating Kali Virtual Machines" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                                New-KaliVm -LabImageDirectory $LabImageDirectory -DefaultProcessorCount $DefaultProcessorCount -Memory $Memory -SwitchName $switchName
                            }
                        }

                        Write-ToLogFile "$(Get-TimeStamp) All processing completed successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    }
                    else {
                        return
                    }

                    # Display all VMs
                    Get-LabVM -LabImageDirectory $LabImageDirectory | Format-Table
                }
            }
            else {
                return
            }
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }

    end {
        Write-Output "Logging disabled. Please see $($LabImageDirectory) for logging information."
    }
}
