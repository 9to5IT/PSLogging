#requires -version 4
<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS Server
  Mandatory. The vCenter Server or ESXi Host the script will connect to, in the format of IP address or FQDN.

.INPUTS Credentials
  Mandatory. The user account credendials used to connect to the vCenter Server of ESXi Host.

.OUTPUTS Log File
  The script log file stored in C:\Windows\Temp\<name>.log

.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  #Script parameters go here
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins
Import-Module PSLogging
Add-PSSnapin VMware.VimAutomation.Core

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '1.0'

#Log File Info
$sLogPath = 'C:\Windows\Temp'
$sLogName = '<script_name>.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Connect-VMwareServer {
  Param ([Parameter(Mandatory=$true)][string]$VMServer)

  Begin {
    Write-LogInfo -LogPath $sLogFile -Message "Connecting to VMware environment [$VMServer]..."
  }

  Process {
    Try {
      $oCred = Get-Credential -Message 'Enter credentials to connect to vSphere Server or Host'
      Connect-VIServer -Server $VMServer -Credential $oCred
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  End {
    If ($?) {
      Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
      Write-LogInfo -LogPath $sLogFile -Message ' '
    }
  }
}

<#

Function <FunctionName> {
  Param ()

  Begin {
    Write-LogInfo -LogPath $sLogFile -Message '<description of what is going on>...'
  }

  Process {
    Try {
      <code goes here>
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  End {
    If ($?) {
      Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
      Write-LogInfo -LogPath $sLogFile -Message ' '
    }
  }
}

#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
$Server = Read-Host 'Specify the vCenter Server or ESXi Host to connect to (IP or FQDN)?'
Connect-VMwareServer -VMServer $Server
#Script Execution goes here
Stop-Log -LogPath $sLogFile
