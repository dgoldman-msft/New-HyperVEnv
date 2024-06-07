$script:ModuleRoot = $PSScriptRoot
# Import internal functions and module PSFramework configurations
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }
# Import Public Functions
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\functions" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }
# Import XML View Files
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\xml" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }