function Write-ToLogFile {
    <#
        .SYNOPSIS
            Save output

        .DESCRIPTION
            Overload function for Write-Output

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.


        .PARAMETER LabImageDirectory
            Logging directory

        .PARAMETER StringObject
            Inbound object to be printed and saved to log

        .EXAMPLE
            None

        .NOTES
            None
    #>

    [OutputType('System.String')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]
        $LabImageDirectory,

        [string]
        $LoggingDirectory = "Logging",

        [Parameter(Mandatory = $True, Position = 0)]
        [string]
        $StringObject
    )

    process {
        if (-NOT(Test-Path -Path (Join-Path -Path $LabImageDirectory -ChildPath $LoggingDirectory))) {
            if ($PSCmdlet.ShouldProcess("Creating New Logging Directory")) {
                New-Item -Path (Join-Path -Path $LabImageDirectory -ChildPath $LoggingDirectory) -ItemType Directory -ErrorAction Stop | Out-Null
            }
        }

        try {
            # Console and log file output
            Write-Output $StringObject
            Out-File -FilePath (Join-Path $LabImageDirectory\$LoggingDirectory -ChildPath "Logging.txt") -InputObject $StringObject -Encoding utf8 -Append -ErrorAction Stop
        }
        catch {
            Write-Output "$(Get-TimeStamp) ERROR: $_"
            return
        }
    }
}