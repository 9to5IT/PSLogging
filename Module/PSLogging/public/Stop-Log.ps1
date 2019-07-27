Function Stop-Log
{
    <#
  .SYNOPSIS
    Write closing data to log file & exits the calling script

  .DESCRIPTION
    Writes finishing logging data to specified log file and then exits the calling script

  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write finishing data to. Example: C:\Windows\Temp\Test_Script.log

  .PARAMETER NoExit
    Optional. If parameter specified, then the function will not exit the calling script, so that further execution can occur (like Send-Log)

  .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log"

    Writes the closing logging information to the log file and then exits the calling script.

    Note: If you don't specify the -NoExit parameter, then the script will exit the calling script.

  .EXAMPLE
    Stop-Log -LogPath "C:\Windows\Temp\Test_Script.log" -NoExit

    Writes the closing logging information to the log file but does not exit the calling script. This then
    allows you to continue executing additional functionality in the calling script (such as calling the
    Send-Log function to email the created log to users).
  #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("log", "csv", "json", "xml", "cmtrace")]  
        [string]$LogFormat,
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]$NoExit,
        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$ToScreen,
        [Parameter(Mandatory = $false)]
        [switch]$ToEventLog,          
        [Parameter(Mandatory = $false)]
        [switch]$Banner
    )

    Process
    {

        $Msg = [PSCustomObject]@{
            TimeStamp   = Get-LogDate
            MessageType = "INFO"
            Message     = "Finished processing at [$(Get-LogDate)]."
        }

        #Write Content to Log        
        If ( $Banner -eq $True )
        {
            if($LogFormat -eq "log")
            {
                Add-Content -Path $LogPath -Value "$(Get-LogDate);INFO;"
                Add-Content -Path $LogPath -Value "$(Get-LogDate);INFO;***************************************************************************************************"
                Add-Content -Path $LogPath -Value "$(Get-LogDate);INFO;Finished processing at [$(Get-LogDate)]."
                Add-Content -Path $LogPath -Value "$(Get-LogDate);INFO;***************************************************************************************************"
            }
        }
        else
        {
            if($LogFormat -eq "log")
            {
                Add-Content -Path $LogPath -Value "$(Get-LogDate);INFO;Finished processing at [$(Get-LogDate)]."
            }

            if($LogFormat -eq "xml")
            {
                [array]$Log = Import-Clixml $LogPath 
                $Log += $Msg | Select-Object TimeStamp, MessageType, Message 
                $Log | Export-Clixml $LogPath
            }

           if($LogFormat -eq "json")
            {
                [array]$Log = Get-Content $LogPath | ConvertFrom-Json
                $Log += $Msg | Select-Object TimeStamp, MessageType, Message 
                $Log | ConvertTo-Json | Out-File $LogPath
            }

            if ($LogFormat -eq "csv")
            {
                [array]$Log = Import-Csv $LogPath 
                $Log += $Msg | Select-Object TimeStamp, MessageType, Message 
                $Log | Export-Csv $LogPath -UseCulture -NoTypeInformation
            }
            if ($LogFormat -eq "cmtrace")
            {           
                $toLog = "{0} `$$<{1}><{2}><thread={3}>" -f ($Msg.MessageType + ":" + $Msg.Message), $LogName, $Msg.TimeStamp, $pid
                $toLog | Out-File -Append -Encoding UTF8 -FilePath $LogPath
            }            
        }

        #Write Content to the EventViewer        
        If ( $ToEventLog -eq $True )
        {
            $LogBaseName = Get-Item $LogPath | Select-Object -ExpandProperty BaseName          
            Write-EventLog -LogName "Application" -Source $LogBaseName -EventID 3001 -EntryType Information -Message "$($LogBaseName) finished" -Category 1          
        }

        #Write to screen for debug mode
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug "Finished processing at [$(Get-LogDate)]."
        Write-Debug "***************************************************************************************************"

        #Write to screen for ToScreen mode
        If ( $ToScreen -eq $True )
        {
            Write-Output ""
            Write-Output "***************************************************************************************************"
            Write-Output "Finished processing at [$(Get-LogDate)]."
            Write-Output "***************************************************************************************************"
        }

        #Exit calling script if NoExit has not been specified or is set to False
        If ( !($NoExit) -or ($NoExit -eq $False) )
        {
            Exit
        }
    }
}
