###
# Author: Luca Sturlese
# URL: http://9to5IT.com
###

Set-StrictMode -Version Latest

# region Load of module functions 
$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

# Load the separate function files from the private and public folders.
$AllFunctions = $PublicFunctions + $PrivateFunctions
foreach ($function in $AllFunctions)
{
    try
    {
        . $function.Fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($function.fullname): $_"
    }
}

# Export the public functions
Export-ModuleMember -Function $PublicFunctions.BaseName
