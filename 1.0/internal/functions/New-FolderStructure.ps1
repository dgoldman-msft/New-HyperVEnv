
function New-FolderStructure {
    <#
        .SYNOPSIS
            Build Directory Structure

        .DESCRIPTION
            This function will build out a directory structure to hold VM's and scripts

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .EXAMPLE
            C:\PS> New-FolderStructure

            Check and create necessary directories

        .NOTES
            Internal function
    #>

    [OutputType('System.Boolean')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]
        $LabImageDirectory
    )

    begin { Write-ToLogFile "$(Get-TimeStamp) Building New Directory Structure" -LabImageDirectory $LabImageDirectory -ErrorAction Stop }

    process {
        try {
            # Check for dependencies
            if (-NOT( Test-Path -Path $LabImageDirectory ) ) {
                if ($PSCmdlet.ShouldProcess("Creating New Default Lab Directory")) {
                    New-Item -Path $LabImageDirectory -ItemType Directory -ErrorAction Stop | Out-Null
                }
            }
            else {
                Write-ToLogFile "$(Get-TimeStamp) Folder: $($LabImageDirectory) already exists" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            }

            # Create sub directories
            if (New-SubDirectory -LabImageDirectory $LabImageDirectory) { return $true } else { return $false }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Directory Error: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}