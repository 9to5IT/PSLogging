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

.OUTPUTS
  <Outputs if any, otherwise state None>

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
Add-PSSnapin VMware.VimAutomation.Core

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Connect-VMwareServer {
  Param ([Parameter(Mandatory=$true)][string]$VMServer)

  Begin {
    Write-Host "Connecting to VMware environment [$VMServer]..."
  }

  Process {
    Try {
      $oCred = Get-Credential -Message 'Enter credentials to connect to vSphere Server or Host'
      Connect-VIServer -Server $VMServer -Credential $oCred
    }

    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }

  End {
    If ($?) {
      Write-Host 'Completed Successfully.'
      Write-Host ' '
    }
  }
}

<#

Function <FunctionName> {
  Param ()

  Begin {
    Write-Host '<description of what is going on>...'
  }

  Process {
    Try {
      <code goes here>
    }

    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }

  End {
    If ($?) {
      Write-Host 'Completed Successfully.'
      Write-Host ' '
    }
  }
}

#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$Server = Read-Host 'Specify the vCenter Server or ESXi Host to connect to (IP or FQDN)?'
Connect-VMwareServer -VMServer $Server
#Script Execution goes here