function Export-Log
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Outfile,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet("Csv", "Json", "Xml")]
        [string]$Format        
    )
     
    $Data = Import-Csv -Path $LogPath -Delimiter ";" -Header TimeStamp, MessageType, Message #needs foutafhandeling

    if ($Data)
    {
        if ($Format -eq "Csv")
        {
            $Data | Export-Csv $Outfile -UseCulture -NoTypeInformation
        }

        if ($Format -eq "Json")
        {
            $Data | ConvertTo-Json | Out-File $Outfile
        }

        if ($Format -eq "Xml")
        {
            $Data | Export-Clixml $Outfile
        }    
    }
    else
    {
        Write-Error "Cannot export, no data or not a correct log file"
    }
}



