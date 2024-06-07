function Install-7Zip {
    <#
        .SYNOPSIS
            Install 7-zip

        .DESCRIPTION
            This function will download and install 7-Zip

        .EXAMPLE
            C:\PS> Install-7Zip

            Download and silently install 7-Zip based on the processor type

        .NOTES
            Internal function
    #>

    [OutputType('System.Boolean')]
    [CmdletBinding(SupportsShouldProcess)]
    param()

    begin { Write-ToLogFile "$(Get-TimeStamp) Checking for 7-Zip" -LabImageDirectory $LabImageDirectory -ErrorAction Stop }

    process {
        try {
            # Check if 7-Zip is installed, if not, throw an error
            if (-NOT( Test-Path "C:\Program Files\7-Zip\7z.exe" )) {
                Write-ToLogFile "$(Get-TimeStamp) Checking processor type" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                $type = systeminfo | Select-String -Pattern "system type:"
                $type -match "x86|x64"
                $proc = $matches[0]
                $7ZipUrl = if ($proc -eq 'x86') { 'https://www.7-zip.org/a/7z2404.msi' } else { 'https://www.7-zip.org/a/7z2404-x64.msi' }

                Write-ToLogFile "$(Get-TimeStamp) Downloading 7-Zip" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                $7Zipfile = $7ZipUrl -match "7z.*"
                Invoke-WebRequest -Uri $7ZipUrl -OutFile "$ENV:Temp\$7Zipfile" -UseBasicParsing -ErrorAction Stop

                Write-ToLogFile "$(Get-TimeStamp) Installing 7-Zip. Please be patient" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                if ($PSCmdlet.ShouldProcess("Installing 7Zip from $7Zipfile")) {
                    Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i `"$ENV:Temp\$7Zipfile`" /qn" -ErrorAction Stop
                    Write-ToLogFile "$(Get-TimeStamp) 7-Zip installation complete!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    return $true
                }
            }
            else {
                Write-ToLogFile "$(Get-TimeStamp) 7-Zip found" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                return $true
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $false
        }
    }
}