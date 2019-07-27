Function Write-LogEntry
{
    <#
    .SYNOPSIS
    Writes a message to specified log file
    .DESCRIPTION
    Appends a new message to the specified log file
    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
    
    .PARAMETER MessageType
    Mandatory. Allowed message types: INFO, WARNING, ERROR, CRITICAL, START, STOP, SUCCESS, FAILURE
    .PARAMETER Message
    Mandatory. The string that you want to write to the log
    .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.
    
    .PARAMETER EntryDateTime
    Optional. By default a current date and time is used but it is possible provide any other correct date/time.
    
    .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.
    
    .PARAMETER
    .INPUTS
    Parameters above
    .OUTPUTS
    None or String
    .NOTES
    
	Current version:  1.2.0
	
	Authors: 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
    
    Inspired and partially based on PSLogging module authored by Luca Sturlese - https://github.com/9to5IT/PSLogging
      
    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files
    .LINK
    https://github.com/it-praktyk/PSLogging
    
    .LINK
    https://www.linkedin.com/in/sciesinskiwojciech
    
    .EXAMPLE
    Write-LogEntry -LogPath "C:\Windows\Temp\Test_Script.log" -MessageType CRITICAL -Message "This is a new line which I am appending to the end of the log file."
    Writes a new critical log message to a new line in the specified log file.
    
  #>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [ValidateSet("log", "csv", "json", "xml", "cmtrace")] 
        [string]$LogFormat,
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [Switch]$ToFile,
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [string]$LogPath,
        [Parameter(Mandatory = $false)]
        [switch]$ToScreen,
        [Parameter(Mandatory = $false)]
        [switch]$ToEventLog,
        [Parameter(Mandatory = $true, HelpMessage = "Allowed values: INFO, WARNING, ERROR")]
        [ValidateSet("INFO", "WARNING", "ERROR")] 
        [String]$MessageType = "INFO",
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias("EventMessage", "EntryMessage")]
        [string]$Message            
    )
    
    Process
    {
        
        $Msg = [PSCustomObject]@{
            TimeStamp   = Get-LogDate
            MessageType = $MessageType.ToUpper()
            Message     = $Message        
        }
                                 
        $MessageToFile = "{0};{1};{2}" -f $Msg.TimeStamp, $Msg.MessageType, $Msg.Message            
        $MessageToScreen = "[{0}] {1}: {2}" -f $Msg.TimeStamp, $Msg.MessageType, $Msg.Message
                    
        #Write Content to Log      
        If ($ToFile -eq $true)
        {           
            if ($LogFormat -eq "log")
            {
                Add-Content -Path $LogPath -Value $MessageToFile       
            }

            if ($LogFormat -eq "xml")
            {
                
                [array]$Log = Import-Clixml $LogPath 
                $Log += $Msg | Select-Object TimeStamp, MessageType, Message 
                $Log | Export-Clixml $LogPath
            }

            if ($LogFormat -eq "json")
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
                $toLog = "{0} `$$<{1}><{2}><thread={3}>" -f ($Msg.MessageType + ":" + $Msg.Message), $LogPath, $Msg.TimeStamp, $pid
                $toLog | Out-File -Append -Encoding UTF8 -FilePath $LogPath
            }            
        }
  
        #Write Content to the EventViewer
        If ( $ToEventLog -eq $True )
        {
            $LogBaseName = Get-Item $LogPath | Select-Object -ExpandProperty BaseName  
            Write-EventLog -LogName "Application" -Source $LogBaseName -EventID 3001 -EntryType $Msg.MessageType -Message "$($Msg.Message)" -Category 1                   
        }

        #Write to screen for debug mode
        Write-Debug $MessageToScreen
        
        #Write to screen for ToScreen mode
        If ($ToScreen -eq $True)
        {          
            if ($MessageType -eq "ERROR")
            {
                Write-Error -Message $MessageToScreen   
            }
            elseif ($MessageType -eq "WARNING")
            {
                Write-Warning -Message $MessageToScreen  
            }
            else {
                Write-Output -Message $MessageToScreen    
            }              
        }
        
    }
}