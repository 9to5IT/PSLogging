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
  <Example goes here. Repeat this attribute for more than one example>

  <Example explanation goes here>
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Add VMware PowerCLI Snap-Ins
Add-PSSnapin VMware.VimAutomation.Core

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Connect-VMwareServer {
  Param ([Parameter(Mandatory = $true)][string]$VMServer)

  Try {
    $oCred = Get-Credential -Message 'Enter credentials to connect to vSphere Server or Host'
    Connect-VIServer -Server $VMServer -Credential $oCred
  }

  Catch {
    Break
  }
}

<#

Function <FunctionName> {
  Param ()

  Try {
    <code goes here>
  }

  Catch {
    Break
  }
}

#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$Server = Read-Host 'Specify the vCenter Server or ESXi Host to connect to (IP or FQDN)?'
Connect-VMwareServer -VMServer $Server
#Script Execution goes here