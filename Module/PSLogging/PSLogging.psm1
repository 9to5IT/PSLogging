###
# Author: Luca Sturlese
# URL: http://9to5IT.com
# Author: Wojciech Sciesinski wojciech[at]sciesinski[dot]net
# URL: https://www.linkedin.com/in/sciesinskiwojciech
###

Set-StrictMode -Version Latest


Function Start-Log {
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
    Current version:  1.5
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net
	
    .LINK
	https://github.com/9to5IT/PSLogging	

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
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$LogName,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$ScriptVersion,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$ToScreen
    )
    
    Process {
        $sFullPath = Join-Path -Path $LogPath -ChildPath $LogName
        
        #Check if file exists and delete if it does
        If ((Test-Path -Path $sFullPath)) {
            Remove-Item -Path $sFullPath -Force
        }
        
        #Create file and start logging
        New-Item -Path $sFullPath –ItemType File
        
        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)]."
        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value ""
        Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion]."
        Add-Content -Path $sFullPath -Value ""
        Add-Content -Path $sFullPath -Value "***************************************************************************************************"
        Add-Content -Path $sFullPath -Value ""
        
        #Write to screen for debug mode
        Write-Debug "***************************************************************************************************"
        Write-Debug "Started processing at [$([DateTime]::Now)]."
        Write-Debug "***************************************************************************************************"
        Write-Debug ""
        Write-Debug "Running script version [$ScriptVersion]."
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug ""
        
        #Write to scren for ToScreen mode
        If ($ToScreen -eq $True) {
            Write-Output "***************************************************************************************************"
            Write-Output "Started processing at [$([DateTime]::Now)]."
            Write-Output "***************************************************************************************************"
            Write-Output ""
            Write-Output "Running script version [$ScriptVersion]."
            Write-Output ""
            Write-Output "***************************************************************************************************"
            Write-Output ""
        }
    }
}

Function Write-LogEntry {
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
    
    .PARAMETER ConvertTimeToUTF
    # Need be filled

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
    
    TODO
    Updated examples - add additional with new implemented parameters
    Implement converting day/time to UTF
    Output with colors (?) - Write-Host except Write-Output need to be used
    
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
        [Switch]$ToFile,
        [Parameter(Mandatory = $false, ParameterSetName = "WriteToFile")]
        [string]$LogPath,
        [Parameter(Mandatory = $true, HelpMessage = "Allowed values: INFO, WARNING, ERROR, CRITICAL, START, STOP, SUCCESS, FAILURE")]
        [ValidateSet("INFO", "WARNING", "ERROR", "CRITICAL", "START", "STOP", "SUCCESS", "FAILURE")]
        [String]$MessageType,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias("EventMessage", "EntryMessage")]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [switch]$TimeStamp,
        [Parameter(Mandatory = $false)]
        [Alias("EventDateTime", "EntryDate", "MessageDate")]
        [DateTime]$EntryDateTime = $([DateTime]::Now),
        [Parameter(Mandatory = $false)]
        [switch]$ToScreen
        
    )
    
    
    
    Process {
        
        #Capitalize MessageType value
        [String]$CapitalizedMessageType = $MessageType.ToUpper()
        
        #A padding used to allign columns in output file
        [String]$Padding = " " * $(10 - $CapitalizedMessageType.Length)
        
        #Add TimeStamp to message if required
        If ($TimeStamp -eq $True) {
            
            [String]$MessageToFile = "[{0}][{1}{2}][{3}]" -f $EntryDateTime, $CapitalizedMessageType, $Padding, $Message
            
            [String]$MessageToScreen = "[{0}] {1}: {2}" -f $EntryDateTime, $CapitalizedMessageType, $Message
            
        }
        Else {
            
            [String]$MessageToFile = "[{0}{1}][{2}]" -f $type, $Padding, $Message
            
            [String]$MessageToScreen = "{0}: {1}" -f $type, $Message
        }
        
        #Write Content to Log
        
        If ($ToFile -eq $true) {
            
            Add-Content -Path $LogPath -Value $MessageToFile
            
        }
        
        #Write to screen for debug mode
        Write-Debug $MessageToScreen
        
        #Write to scren for ToScreen mode
        If ($ToScreen -eq $True) {
            
            Write-Output $MessageToScreen
            
        }
        
    }
}

Function Write-LogInfo {
<#
    .SYNOPSIS
    Writes informational message to specified log file
    
    .DESCRIPTION
    Appends a new informational message to the specified log file
    
    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
    
    .PARAMETER Message
    Mandatory. The string that you want to write to the log
    
    .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.
    
    .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.
    
    .INPUTS
    Parameters above
    
    .OUTPUTS
    None
    
    .NOTES
	Current version:  2.1
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net
    
	.LINK
	https://github.com/9to5IT/PSLogging	

    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files
  
    .EXAMPLE
    Write-LogInfo -LogPath "C:\Windows\Temp\Test_Script.log" -Message "This is a new line which I am appending to the end of the log file."
    Writes a new informational log message to a new line in the specified log file.
#>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$TimeStamp,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$ToScreen
    )
    
    Process {
        
        Write-LogEntry -LogPath $LogPath -MessageType INFO -Message $Message -TimeStamp:$TimeStamp -ToScreen:$ToScreen
        
    }
}


Function Write-LogWarning {
<#
    .SYNOPSIS
    Writes warning message to specified log file

    .DESCRIPTION
    Appends a new warning message to the specified log file. Automatically prefixes line with WARNING:

    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log

    .PARAMETER Message
    Mandatory. The string that you want to write to the log

    .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.

    .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.

    .INPUTS
    Parameters above

    .OUTPUTS
    None

    .NOTES
	Current version:  2.1
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net
    
	.LINK
	https://github.com/9to5IT/PSLogging	

    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

    .EXAMPLE
    Write-LogWarning -LogPath "C:\Windows\Temp\Test_Script.log" -Message "This is a warning message."

    Writes a new warning log message to a new line in the specified log file.
#>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$TimeStamp,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$ToScreen
    )
    
    Process {
        
        Write-LogEntry -LogPath $LogPath -MessageType WARNING -Message $Message -TimeStamp:$TimeStamp -ToScreen:$ToScreen
        
    }
}

Function Write-LogError {
<#
    .SYNOPSIS
    Writes error message to specified log file

    .DESCRIPTION
    Appends a new error message to the specified log file. Automatically prefixes line with ERROR:

    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log

    .PARAMETER Message
    Mandatory. The description of the error you want to pass (pass your own or use $_.Exception)

    .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.

    .PARAMETER ExitGracefully
    Optional. If parameter specified, then runs Stop-Log and then exits script

    .PARAMETER ToScreen
    Optional. When parameter specified will display the content to screen as well as write to log file. This provides an additional
    another option to write content to screen as opposed to using debug mode.

    .INPUTS
    Parameters above

    .OUTPUTS
    None

	.NOTES
    Current version:  2.1
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net

    .LINK
	https://github.com/9to5IT/PSLogging	

    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

    .EXAMPLE
    Write-LogError -LogPath "C:\Windows\Temp\Test_Script.log" -Message $_.Exception -ExitGracefully

    Writes a new error log message to a new line in the specified log file. Once the error has been written,
    the Stop-Log function is excuted and the calling script is exited.

    .EXAMPLE
    Write-LogError -LogPath "C:\Windows\Temp\Test_Script.log" -Message $_.Exception

    Writes a new error log message to a new line in the specified log file, but does not execute the Stop-Log
    function, nor does it exit the calling script. In other words, the only thing that occurs is an error message
    is written to the log file and that is it.

    Note: If you don't specify the -ExitGracefully parameter, then the script will not exit on error.
#>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$TimeStamp,
        [Parameter(Mandatory = $false, Position = 4)]
        [switch]$ExitGracefully,
        [Parameter(Mandatory = $false, Position = 5)]
        [switch]$ToScreen
    )
    
    Process {
        
        Write-LogEntry -LogPath $LogPath -MessageType ERROR -Message $Message -TimeStamp:$TimeStamp -ToScreen:$ToScreen
        
        #If $ExitGracefully = True then run Log-Finish and exit script
        If ($ExitGracefully -eq $True) {
            
            Add-Content -Path $LogPath -Value " "
            
            Stop-Log -LogPath $LogPath
            
            Break
            
        }
    }
}

Function Stop-Log {
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
    Current version:  1.7
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net
 
    .LINK
	https://github.com/9to5IT/PSLogging	

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
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogPath,
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]$NoExit,
        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$ToScreen
    )
    
    Process {
        Add-Content -Path $LogPath -Value ""
        Add-Content -Path $LogPath -Value "***************************************************************************************************"
        Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
        Add-Content -Path $LogPath -Value "***************************************************************************************************"
        
        #Write to screen for debug mode
        Write-Debug ""
        Write-Debug "***************************************************************************************************"
        Write-Debug "Finished processing at [$([DateTime]::Now)]."
        Write-Debug "***************************************************************************************************"
        
        #Write to scren for ToScreen mode
        If ($ToScreen -eq $True) {
            Write-Output ""
            Write-Output "***************************************************************************************************"
            Write-Output "Finished processing at [$([DateTime]::Now)]."
            Write-Output "***************************************************************************************************"
        }
        
        #Exit calling script if NoExit has not been specified or is set to False
        If (!($NoExit) -or ($NoExit -eq $False)) {
            Exit
        }
    }
}

Function Send-Log {
  <#
    .SYNOPSIS
    Emails completed log file to list of recipients

    .DESCRIPTION
    Emails the contents of the specified log file to a list of recipients

    .PARAMETER SMTPServer
    Mandatory. FQDN of the SMTP server used to send the email. Example: smtp.google.com

    .PARAMETER LogPath
    Mandatory. Full path of the log file you want to email. Example: C:\Windows\Temp\Test_Script.log

    .PARAMETER EmailFrom
    Mandatory. The email addresses of who you want to send the email from. Example: "admin@9to5IT.com"

    .PARAMETER EmailTo
    Mandatory. The email addresses of where to send the email to. Seperate multiple emails by ",". Example: "admin@9to5IT.com, test@test.com"

    .PARAMETER EmailSubject
    Mandatory. The subject of the email you want to send. Example: "Cool Script - [" + (Get-Date).ToShortDateString() + "]"

    .INPUTS
    Parameters above

    .OUTPUTS
    Email sent to the list of addresses specified

    .NOTES
    Current version:  1.3
	
	Version history: github.com/9to5IT/PSLogging/VERSIONS.MD
	
	Authors: 
	- Luca Sturlese 
	- Wojciech Sciesinski wojciech[at]sciesinski[dot]net

    .LINK
	https://github.com/9to5IT/PSLogging	

    .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

    .EXAMPLE
    Send-Log -SMTPServer "smtp.google.com" -LogPath "C:\Windows\Temp\Test_Script.log" -EmailFrom "admin@9to5IT.com" -EmailTo "admin@9to5IT.com, test@test.com" -EmailSubject "Cool Script"

    Sends an email with the contents of the log file as the body of the email. Sends the email from admin@9to5IT.com and sends
    the email to admin@9to5IT.com and test@test.com email addresses. The email has the subject of Cool Script. The email is
    sent using the smtp.google.com SMTP server.
  #>
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$SMTPServer,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$LogPath,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$EmailFrom,
        [Parameter(Mandatory = $true, Position = 3)]
        [string]$EmailTo,
        [Parameter(Mandatory = $true, Position = 4)]
        [string]$EmailSubject
    )
    
    Process {
        Try {
            $sBody = (Get-Content $LogPath | Out-String)
            
            #Create SMTP object and send email
            $oSmtp = new-object Net.Mail.SmtpClient($SMTPServer)
            $oSmtp.Send($EmailFrom, $EmailTo, $EmailSubject, $sBody)
            Exit 0
        }
        
        Catch {
            Exit 1
        }
    }
}