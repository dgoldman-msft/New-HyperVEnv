
function Get-Kali {
    <#
        .SYNOPSIS
            Download Kali Linux

        .DESCRIPTION
            This function will download a Kali Linux image

        .PARAMETER DownloadKali
            Directory to store / install lab images.

        .PARAMETER LabImageDirectory
            Directory to store / install lab images.

        .EXAMPLE
            C:\PS> Get-Kali

            Download a Kali Linux image

        .NOTES
            Internal function
    #>

    [OutputType('System.Boolean')]
    [CmdletBinding()]
    param(
        [string]
        $LabImageDirectory
    )

    begin {
        Write-ToLogFile "$(Get-TimeStamp) Download an image of Kali Linux" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
        Write-ToLogFile "$(Get-TimeStamp) Downloading Kali Linux VHD from https://cdimage.kali.org/" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
        $kaliImageDir = "kali-linux-2024.1-hyperv-amd64"
        $kaliVHDX = "kali-linux-2024.1-hyperv-amd64.vhdx"
        $kaliZipName = "kali-linux-2024.1-hyperv-amd64.7z"
        $kaliVHDUrl = "https://cdimage.kali.org/kali-2024.1/$kaliZipName"
    }

    process {
        try {
            Invoke-WebRequest -Uri $kaliVHDUrl -OutFile "$LabImageDirectory\KaliImages\$kaliZipName" -UseBasicParsing -ErrorAction Stop

            # If the request is successful, the status code will be 200
            if (Test-Path -Path "$LabImageDirectory\KaliImages\$kaliZipName") {
                Write-ToLogFile "$(Get-TimeStamp) Download of Kali Linux was successful. Creating Kali Linux VM" -LabImageDirectory $LabImageDirectory -ErrorAction Stop

                # Unzip the .7z file
                Write-ToLogFile "$(Get-TimeStamp) Unzipping the $($kaliZipName)" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                Set-Alias -Name 7zip -Value "$env:ProgramFiles\7-Zip\7z.exe"
                $destinationUnzipPath = "$LabImageDirectory\KaliVms"
                7zip x "$LabImageDirectory\KaliImages\$kaliZipName" "-o$($destinationUnzipPath)" -aoa -r -ErrorAction Stop

                # Test that files unzipped ok
                if (-NOT(Test-Path -Path "$LabImageDirectory\KaliVms\$kaliImageDir\$kaliVHDX")) {
                    Write-ToLogFile "$(Get-TimeStamp) $($kaliZipName) failed to unzipped successfully!" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
                    return $true
                }
            }
        }
        catch {
            Write-ToLogFile "$(Get-TimeStamp) Error detected: $_" -LabImageDirectory $LabImageDirectory -ErrorAction Stop
            return $true
        }
    }
}