function New-SubDirectory {
    <#
        .SYNOPSIS
            Build Sub Directory Structure

        .DESCRIPTION
            This function will build out a sub directory structure to hold VM's and scripts

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .EXAMPLE
            C:\PS> New-SubDirectory

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
        Write-ToLogFile "$(Get-TimeStamp) Building New Sub Directory Structure" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
        $subDirectories = @('KaliImages', 'KaliVMs', 'WinImages', 'WinVms')
        $vmSubDirectories = @("WinDC", "WinServer", "Win11Client")
    }

    process {
        try {
            foreach ($dir in $subDirectories) {
                $path = Join-Path $LabImageDirectory -ChildPath $dir
                if (-NOT(Test-Path -Path $path)) {
                    if ($PSCmdlet.ShouldProcess("Creating New Default Lab SubDirectory $path")) {
                        New-Item -Path $path -ItemType Directory -ErrorAction Stop | Out-Null
                        Write-ToLogFile "$(Get-TimeStamp) $path created!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    }
                }
            }

            foreach ($dir in $vmSubDirectories) {
                $path = Join-Path "$LabImageDirectory\WinVms" -ChildPath $dir
                if (-NOT(Test-Path -Path $path)) {
                    if ($PSCmdlet.ShouldProcess("Creating New Default Subfolder Lab SubDirectory $path")) {
                        New-Item -Path $path -ItemType Directory -ErrorAction Stop | Out-Null
                        Write-ToLogFile "$(Get-TimeStamp) $path created!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    }
                }
            }
            return $true
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}