
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

    begin {
        if (-NOT(Test-Path -Path $LabImageDirectory) ) {
            if ($PSCmdlet.ShouldProcess("Creating New Default Lab Directory Structure")) {
                New-Item -Path $LabImageDirectory -ItemType Directory -ErrorAction Stop | Out-Null
                Write-ToLogFile "$(Get-TimeStamp) Creating New Default Lab Directory Structure" -LabImageDirectory $LabImageDirectory -ErrorAction Stop }
            }
            else {
                Write-ToLogFile "$(Get-TimeStamp) Folder: $($LabImageDirectory) already exists" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            }
        }

    process {
        try {
            if (New-SubDirectory -LabImageDirectory $LabImageDirectory) { return $true } else { return $false }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Directory Error: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}