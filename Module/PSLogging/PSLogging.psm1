###
# Author: Luca Sturlese
# URL: http://9to5IT.com
###

Set-StrictMode -Version Latest

Enum PSLoggingState
{
  Stopped
  Started
}

# Init State
Set-Variable -Name PSLoggingState -Value Stopped -Option allscope -Scope Global | Out-Null

<#
  .SYNOPSIS
    Print Exception

  .DESCRIPTION
    Print Exception Details
#>

function Script:PrintPSLoggingException{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ErrorRecord]$Record,
        [Parameter(Mandatory=$false)]
        [switch]$ShowStack
    )       
    $formatstring = "{0}`n{1}"
    $fields = $Record.FullyQualifiedErrorId,$Record.Exception.ToString()
    $ExceptMsg=($formatstring -f $fields)
    $Stack=$Record.ScriptStackTrace
    Write-Host "[PSLogging] -> " -NoNewLine -ForegroundColor Red; 
    Write-Host "$ExceptMsg" -ForegroundColor Yellow
    if($ShowStack){
        Write-Host "--stack begin--" -ForegroundColor Green
        Write-Host "$Stack" -ForegroundColor Gray  
        Write-Host "--stack end--`n" -ForegroundColor Green       
    }
} 

Function Start-Log {
  <#
  .SYNOPSIS
    Creates a new log file

  .DESCRIPTION
    Creates a log file with the path and name specified in the parameters. Checks if log file exists, and if it does deletes it and creates a new one.
    Once created, writes initial logging data

  .PARAMETER LogPath
    Mandatory. Path of where log is to be created. Example: C:\Windows\Temp

  .PARAMETER ScriptVersion
    Mandatory. Version of the running script which will be written in the log. Example: 1.5

  .INPUTS
    Parameters above

  .OUTPUTS
    Log file created

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

    Version:        1.3
    Author:         Luca Sturlese
    Creation Date:  07/09/15
    Purpose/Change: Resolved issue with New-Item cmdlet. No longer creates error. Tested - all ok.

    Version:        1.4
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

    Version:        1.4.1
    Author:         cybercastor
    Creation Date:  2021-11-20 11:22
    Purpose/Change: MINOR STUFF AND POLISHING Reference: https://github.com/9to5IT/PSLogging/pull/15/commits

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Start-Log -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"

    Creates a new log file with the file path of C:\Windows\Temp\Test_Script.log. Initialises the log file with
    the date and time the log was created (or the calling script started executing) and the calling script's version.
  #>

  [CmdletBinding(SupportsShouldProcess)]

  Param (
    
    [ValidateScript({
      if($_ | Test-Path -PathType Container){
          throw "The Path argument must be a File. Directory paths are not allowed."
      }
      if($_ | Test-Path ) {
          throw "File already exists"
      }
      return $True
    })]
    [Parameter(Mandatory=$true,Position=0)]
    [Alias('f','file')]
    [string]$LogPath,  
    [Parameter(Mandatory=$true)]
    [Alias('v','ver')]
    [string]$ScriptVersion
  )

  
    try{
      If ( $Global:PSLoggingState -eq [PSLoggingState]::Started ){
        throw "Already Started"
      }
      #Create file and start logging
      New-Item -Path $LogPath -ItemType File -Force -EA Stop | Out-Null

      Set-Variable -Name PSLoggingState -Value Started -Option allscope -Scope Global | Out-Null
      Set-Variable -Name PSLoggingLogFile -Value $LogPath -Option allscope,readonly -Scope Global -Force | Out-Null
      
      Add-Content -Path $LogPath -Value "***************************************************************************************************"
      Add-Content -Path $LogPath -Value "Started processing at [$([DateTime]::Now)]."
      Add-Content -Path $LogPath -Value "***************************************************************************************************"
      Add-Content -Path $LogPath -Value ""
      Add-Content -Path $LogPath -Value "Running script version [$ScriptVersion]."
      Add-Content -Path $LogPath -Value ""
      Add-Content -Path $LogPath -Value "***************************************************************************************************"
      Add-Content -Path $LogPath -Value ""

      #Write to scren for ToScreen mode
      If ( $PSBoundParameters.ContainsKey('Verbose') -eq $True ){
        Write-Output "***************************************************************************************************"
        Write-Output "Started processing at [$([DateTime]::Now)]."
        Write-Output "***************************************************************************************************"
        Write-Output ""
        Write-Output "Running script version [$ScriptVersion]."
        Write-Output ""
        Write-Output "***************************************************************************************************"
        Write-Output ""
    }
    
    }catch [Exception]{
        PrintPSLoggingException($_) -ShowStack
    }

}

Function Write-LogInfo {
  <#
  .SYNOPSIS
    Writes informational message to specified log file

  .DESCRIPTION
    Appends a new informational message to the specified log file

  .PARAMETER Message
    Mandatory. The string that you want to write to the log

  .PARAMETER LogPath
    Optional. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
    Can be specified in Start-Log

  .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

    Version:        1.3
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed parameter name from LineValue to Message to improve consistency across functions.

    Version:        1.4
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

    Version:        1.5
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

    Version:        1.5.1
    Author:         cybercastor
    Creation Date:  2021-11-20 11:22
    Purpose/Change: MINOR STUFF AND POLISHING Reference: https://github.com/9to5IT/PSLogging/pull/15/commits

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Write-LogInfo -LogPath "C:\Windows\Temp\Test_Script.log" -Message "This is a new line which I am appending to the end of the log file."

    Writes a new informational log message to a new line in the specified log file.
  #>

  [CmdletBinding(SupportsShouldProcess)]

  Param (
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string]$Message,
    [Parameter(Mandatory=$false,Position=1)]
    [Alias('f','file')]
    [string]$LogPath,
    [Parameter(Mandatory=$false,Position=2)]
    [Alias('t','time')]
    [switch]$TimeStamp
  )

  try{
      If ( $PSBoundParameters.ContainsKey('LogPath') -eq $False ) {
        if( $Global:PSLoggingState -eq [PSLoggingState]::Stopped ){
          throw "Need to specify the LogPath (or call Log-Start)"
        }else{
          $LogPath = $Global:PSLoggingLogFile
        }
      }
      #Add TimeStamp to message if specified
      If ( $TimeStamp -eq $True ) {
        $Message = "[$([DateTime]::Now.GetDateTimeFormats()[19])] $Message"
      }

      $Message = "[INFO]`t$Message"

      If ( $PSBoundParameters.ContainsKey('Verbose') -eq $True ) { Write-Output $Message }
      #Write Content to Log
      Add-Content -Path $LogPath -Value $Message

  }catch [Exception]{
    PrintPSLoggingException($_)
  }
}

Function Write-LogWarning {
  <#
  .SYNOPSIS
    Writes warning message to specified log file

  .DESCRIPTION
    Appends a new warning message to the specified log file. Automatically prefixes line with WARNING:

  .PARAMETER Message
    Mandatory. The string that you want to write to the log

  .PARAMETER LogPath
    Optional. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log

  .PARAMETER TimeStamp
    Optional. When parameter specified will append the current date and time to the end of the line. Useful for knowing
    when a task started and stopped.

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

    Version:        1.2.1
    Author:         cybercastor
    Creation Date:  2021-11-20 11:22
    Purpose/Change: MINOR STUFF AND POLISHING Reference: https://github.com/9to5IT/PSLogging/pull/15/commits

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Write-LogWarning -LogPath "C:\Windows\Temp\Test_Script.log" -Message "This is a warning message."

    Writes a new warning log message to a new line in the specified log file.
  #>

  [CmdletBinding(SupportsShouldProcess)]

  Param (
    [Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)][string]$Message,
    [Parameter(Mandatory=$false)]
    [Alias('f','file')]
    [string]$LogPath,
    [Parameter(Mandatory=$false)]
    [Alias('t','time')]
    [switch]$TimeStamp
  )
  try{

    
    If ( $PSBoundParameters.ContainsKey('LogPath') -eq $False ) {
      if( $Global:PSLoggingState -eq [PSLoggingState]::Stopped ){
        throw "Need to specify the LogPath (or call Log-Start)"
      }else{
        $LogPath = $Global:PSLoggingLogFile
      }
    }
    #Add TimeStamp to message if specified
    If ( $TimeStamp -eq $True ) {
      $Message = "[$([DateTime]::Now.GetDateTimeFormats()[19])] $Message"
    }
    If ( $PSBoundParameters.ContainsKey('Verbose') -eq $True ){ Write-Warning $Message }

    $Message = "[WARN]`t$Message"

    #Write Content to Log
    Add-Content -Path $LogPath -Value $Message

    

  }catch [Exception]{
        PrintPSLoggingException($_)
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

  .PARAMETER Exception
    Optional. If parameter specified, throw an exception

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support. Added -ExitGracefully parameter functionality.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

    Version:        1.3
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed parameter name from ErrorDesc to Message to improve consistency across functions.

    Version:        1.4
    Author:         Luca Sturlese
    Creation Date:  03/09/15
    Purpose/Change: Improved readability and cleaniness of error writing.

    Version:        1.5
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Changed -ExitGracefully parameter to switch type so no longer need to specify $True or $False (see example for info).

    Version:        1.6
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

    Version:        1.7
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

    Version:        1.7.1
    Author:         cybercastor
    Creation Date:  2021-11-20 11:22
    Purpose/Change: MINOR STUFF AND POLISHING Reference: https://github.com/9to5IT/PSLogging/pull/15/commits

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

  [CmdletBinding(SupportsShouldProcess)]

  Param (
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string]$Message,
    [Parameter(Mandatory=$false)]
    [Alias('f','file')]
    [string]$LogPath,
    [Parameter(Mandatory=$false)]
    [Alias('t','time')]
    [switch]$TimeStamp,
    [Parameter(Mandatory=$false)]
    [Alias('e')]
    [switch]$Exception
  )
    try{

     If ( $PSBoundParameters.ContainsKey('LogPath') -eq $False ) {
      if( $Global:PSLoggingState -eq [PSLoggingState]::Stopped ){
        throw "Need to specify the LogPath (or call Log-Start)"
      }else{
        $LogPath = $Global:PSLoggingLogFile
      }
    }

    #Add TimeStamp to message if specified
    If ( $TimeStamp -eq $True ) {
      $Message = "[$([DateTime]::Now.GetDateTimeFormats()[19])] $Message"
    }
    If ( $PSBoundParameters.ContainsKey('Verbose') -eq $True ){ Write-Error $Message }
    $Message = "[ERRO]`t$Message"
    #Write Content to Log
    Add-Content -Path $LogPath -Value $Message

    If ( $Exception -eq $True ) {
      throw $Message
    }

  }catch [Exception]{
      PrintPSLoggingException($_)
  }
}

Function Stop-Log {
  <#
  .SYNOPSIS
    Write closing data to log file & exits the calling script

  .DESCRIPTION
    Writes finishing logging data to specified log file and then exits the calling script

  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  01/08/12
    Purpose/Change: Added option to not exit calling script if required (via optional parameter).

    Version:        1.3
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

    Version:        1.4
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Changed -NoExit parameter to switch type so no longer need to specify $True or $False (see example for info).

    Version:        1.5
    Author:         Luca Sturlese
    Creation Date:  12/09/15
    Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

    Version:        1.4.1
    Author:         cybercastor
    Creation Date:  2021-11-20 11:22
    Purpose/Change: MINOR STUFF AND POLISHING Reference: https://github.com/9to5IT/PSLogging/pull/15/commits

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

  [CmdletBinding(SupportsShouldProcess)]
  Param ()
  try{
      If ( $Global:PSLoggingState -eq [PSLoggingState]::Stopped ){
        throw "Already Stopped"
      }
      Set-Variable -Name PSLoggingState -Value [PSLoggingState]::Stopped -Option allscope -Scope Global | Out-Null
      $LogPath = $Global:PSLoggingLogFile

      Add-Content -Path $LogPath -Value ""
      Add-Content -Path $LogPath -Value "***************************************************************************************************"
      Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
      Add-Content -Path $LogPath -Value "***************************************************************************************************"

      If ( $PSBoundParameters.ContainsKey('Verbose') -eq $True ){
        Write-Output ""
        Write-Output "***************************************************************************************************"
        Write-Output "Finished processing at [$([DateTime]::Now)]."
        Write-Output "***************************************************************************************************"
      }
  }catch [Exception]{
        PrintPSLoggingException($_)
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

  .PARAMETER EmailFrom
    Mandatory. The email addresses of who you want to send the email from. Example: "admin@9to5IT.com"

  .PARAMETER EmailTo
    Mandatory. The email addresses of where to send the email to. Seperate multiple emails by ",". Example: "admin@9to5IT.com, test@test.com"

  .PARAMETER EmailSubject
    Mandatory. The subject of the email you want to send. Example: "Cool Script - [" + (Get-Date).ToShortDateString() + "]"

  .PARAMETER LogPath
    NOT Mandatory. Full path of the log file you want to email, or if not specified the log file use in the last session.,
    which means, the one called in Log-Start. 
    Example: C:\Windows\Temp\Test_Script.log

  .INPUTS
    Parameters above

  .OUTPUTS
    Email sent to the list of addresses specified

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  05.10.12
    Purpose/Change: Initial function development.

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  02/09/15
    Purpose/Change: Added SMTPServer parameter to pass SMTP server as oppposed to having to set it in the function manually.

  .LINK
    http://9to5IT.com/powershell-logging-v2-easily-create-log-files

  .EXAMPLE
    Send-Log -SMTPServer "smtp.google.com" -LogPath "C:\Windows\Temp\Test_Script.log" -EmailFrom "admin@9to5IT.com" -EmailTo "admin@9to5IT.com, test@test.com" -EmailSubject "Cool Script"

    Sends an email with the contents of the log file as the body of the email. Sends the email from admin@9to5IT.com and sends
    the email to admin@9to5IT.com and test@test.com email addresses. The email has the subject of Cool Script. The email is
    sent using the smtp.google.com SMTP server.
  #>

  [CmdletBinding(SupportsShouldProcess)]
  Param (
    [Parameter(Mandatory=$true,Position=0)]
    [Alias('smtp')]
    [string]$SMTPServer,
    [Parameter(Mandatory=$true,Position=1)]
    [Alias('from')]
    [string]$EmailFrom,
    [Parameter(Mandatory=$true,Position=2)]
    [Alias('to')]
    [string]$EmailTo,
    [Parameter(Mandatory=$true,Position=3)]
    [Alias('subject')]
    [string]$EmailSubject,
    [Parameter(Mandatory=$false,Position=4)]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File does not exist"
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a file. Directory paths are not allowed."
        }
        return $true 
    })]
    [string]$LogPath
  )

  try {
      If ( $PSBoundParameters.ContainsKey('LogPath') -eq $False ){
        $LogPath = $Global:PSLoggingLogFile
      }
      $sBody = ( Get-Content $LogPath | Out-String )

      #Create SMTP object and send email
      $oSmtp = new-object Net.Mail.SmtpClient( $SMTPServer )
      $oSmtp.Send( $EmailFrom, $EmailTo, $EmailSubject, $sBody )
      Exit 0
  }catch [Exception]{
        PrintPSLoggingException($_)
  }

}