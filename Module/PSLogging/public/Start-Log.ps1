Function Start-Log
{
    <#
  .SYNOPSIS
    Creates a new log file

  .DESCRIPTION
    Creates a log file with the path and name specified in the parameters. Checks if log file exists, and if it does deletes it and creates a new one.
    Once created, writes initial logging data

  .PARAMETER LogPath
    Mandatory. Path of where log is to be created. Example: C:\Windows\Temp

  .PARAMETER LogName
    Mandatory. Name of log file to be created. Example: Test_Script.log

  .PARAMETER ScriptVersion
    Mandatory. Version of the running script which will be written in the log. Example: 1.5

  .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.

  .INPUTS
    Parameters above

  .OUTPUTS
    Log file created

  .NOTES

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Start-Log -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"

    Creates a new log file with the file path of C:\Windows\Temp\Test_Script.log. Initialises the log file with
    the date and time the log was created (or the calling script started executing) and the calling script's version.
  #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("log", "csv", "json", "xml", "cmtrace")] 
        [string]$LogFormat,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$LogName,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$ScriptVersion,
        [Parameter(Mandatory = $false, Position = 4)]
        [switch]$ToScreen,
        [Parameter(Mandatory = $false)]
        [switch]$ToEventLog,          
        [Parameter(Mandatory = $false)]
        [switch]$Banner
    )

    Process
    {
        $sFullPath = Join-Path -Path $LogPath -ChildPath $LogName

        $Msg = [PSCustomObject]@{
            TimeStamp   = Get-LogDate
            MessageType = "INFO"
            Message     = "Started processing at [$(Get-LogDate)]."
        }

        if($LogFormat -eq "log")
        {
            #Check if file exists and delete if it does
            If ( (Test-Path -Path $sFullPath) )
            {
                Remove-Item -Path $sFullPath -Force
            }

            #Create file and start logging
            New-Item -Path $sFullPath -ItemType File
        }

        #Write Content to Log  
        If ( $Banner -eq $True )
        {
            if ($LogFormat -eq "log")
            {
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;***************************************************************************************************"
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;Started processing at [$(Get-LogDate)]."
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;***************************************************************************************************"
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;"
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;Running script version [$ScriptVersion]."
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;"
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;***************************************************************************************************"
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;"
            }
        }
        else
        {
            if ($LogFormat -eq "log")
            {
                Add-Content -Path $sFullPath -Value "$(Get-LogDate);INFO;Started processing at [$(Get-LogDate)]."
            }

            if ($LogFormat -eq "xml")
            {
                $Msg | Export-Clixml $sFullPath
            }

            if ($LogFormat -eq "json")
            {
                $Msg | ConvertTo-Json | Out-File $sFullPath
            }

            if ($LogFormat -eq "csv")
            {
                $Msg | Export-Csv $sFullPath -UseCulture -NoTypeInformation
            }
            
            if ($LogFormat -eq "cmtrace")
            {           
                $toLog = "{0} `$$<{1}><{2}><thread={3}>" -f ($Msg.MessageType + ":" + $Msg.Message), $LogName, $Msg.TimeStamp, $pid
                $toLog | Out-File -Append -Encoding UTF8 -FilePath $sFullPath
            }
        }

        #Write Content to the EventViewer        
        If ( $ToEventLog -eq $True )
        {
            $LogBaseName = Get-Item $sFullPath | Select-Object -ExpandProperty BaseName
            New-EventLog -LogName "Application" -Source $LogBaseName # needs fix if already exists
            Write-EventLog -LogName "Application" -Source $LogBaseName -EventID 3001 -EntryType Information -Message "$($LogBaseName) $($ScriptVersion) started" -Category 1           
        }

        #Write to screen for debug mode
        Write-Debug "***************************************************************************************************"
        Write-Debug "Started processing at [$(Get-LogDate)]."
        Write-Debug "***************************************************************************************************"
        Write-Debug ""
        Write-Debug "Running script version [$ScriptVersion]."
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug ""

        #Write to screen for ToScreen mode
        If ( $ToScreen -eq $True )
        {
            Write-Output "***************************************************************************************************"
            Write-Output "Started processing at [$(Get-LogDate)]."
            Write-Output "***************************************************************************************************"
            Write-Output ""
            Write-Output "Running script version [$ScriptVersion]."
            Write-Output ""
            Write-Output "***************************************************************************************************"
            Write-Output ""
        }
    }
}