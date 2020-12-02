<#
    .SYNOPSIS
    Configure Exchange Server 2016+ Virtual Directory Url Settings
   
   	Thomas Stensitzki
	
	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
	Version 2.0, 2020-12-02

    Please send ideas, comments and suggestions to support@granikos.eu 
 
    .LINK  
    http://www.granikos.eu/en/scripts 
	
    .DESCRIPTION
	Exchange Server virtual directories (vDirs) require a proper configuration of
    internal and external Urls. This is even more important in a co-existence 
    scenario with legacy Exchange Server versions.

    .NOTES 
    Requirements 
    - Windows Server 2016+
    - Exchange Server 2016+

    Revision History 
    -------------------------------------------------------------------------------- 
    1.0     Initial community release 
	2.0     Updated for Exchange Server 2016, 2019, vNEXT
	
	.PARAMETER InternalUrl
    The internal url FQDN with protocol definition, ie. https://mobile.mcsmemail.de

    .PARAMETER ExternalUrl
    The internal url FQDN with protocol definition, ie. https://mobile.mcsmemail.de
   
	.EXAMPLE
    Configure internal and external url for different host headers 
    .\Set-VirtualDirectoryUrl.ps1 -InternalUrl https://internal.mcsmemail.de -ExternalUrl https://mobile.mcsmemail.de
	
#>

Param(
    [parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage='The internal Url host inclusive protocol, i.e. https://mobile.mcsmemail.de')]
        [string]$InternalUrl,  
    [parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage='The external Url host inclusive protocol, i.e. https://mobile.mcsmemail.de')]
        [string]$ExternalUrl
)

# Fetch Exchange Server 2016+ Servers
$exchangeServers = Get-ExchangeServer | Where {($_.IsE15OrLater -eq $true) -and ($_.ServerRole -ilike "*Mailbox*")}


if($InternalUrl -ne "" -and $exchangeServers -ne $null) {

    # Trim trailing "/"
    if($InternalUrl.EndsWith("/")) {
        $InternalUrl = $InternalUrl.TrimEnd('/')
    }

    Write-Output "The script configures the following servers:"
    $exchangeServers | ft Name, AdminDisplayVersion -AutoSize

    Write-Output "Changing InternalUrl settings"
    Write-Output "New INTERNAL Url: $InternalUrl"
    
    $exchangeServers | %{ Set-ClientAccessService -Identity $_.Name -AutodiscoverServiceInternalUri "$InternalUrl/autodiscover/autodiscover.xml" -Confirm:$false}
    $exchangeServers | Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory -InternalUrl "$InternalUrl/ews/exchange.asmx" -Confirm:$false
    $exchangeServers | Get-OabVirtualDirectory | Set-OabVirtualDirectory -InternalUrl "$InternalUrl/oab" -Confirm:$false
    $exchangeServers | Get-OwaVirtualDirectory | Set-OwaVirtualDirectory -InternalUrl "$InternalUrl/owa" -Confirm:$false
    $exchangeServers | Get-EcpVirtualDirectory | Set-EcpVirtualDirectory -InternalUrl "$InternalUrl/ecp" -Confirm:$false
	$exchangeServers | Get-MapiVirtualDirectory | Set-MapiVirtualDirectory -InternalUrl "$InternalUrl/mapi" -Confirm:$false
    $exchangeServers | Get-ActiveSyncVirtualDirectory | Set-ActiveSyncVirtualDirectory -InternalUrl "$InternalUrl/Microsoft-Server-ActiveSync" -Confirm:$false
    
    Write-Output "InternalUrl changed"
}

if($ExternalUrl -ne "" -and $exchangeServers -ne $null) {

    # Trim trailing "/"
    if($ExternalUrl.EndsWith("/")) {
        $ExternalUrl = $ExternalUrl.TrimEnd('/')
    }
    
    Write-Output "Changing ExternalUrl settings"
    Write-Output "New EXTERNAL Url: $ExternalUrl"

   $exchangeServers | %{ Set-ClientAccessService -Identity $_.Name -AutodiscoverServiceInternalUri "$ExternalUrl/autodiscover/autodiscover.xml" -Confirm:$false }
   $exchangeServers | Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory -ExternalUrl "$ExternalUrl/ews/exchange.asmx" -Confirm:$false
   $exchangeServers | Get-OabVirtualDirectory | Set-OabVirtualDirectory -ExternalUrl "$ExternalUrl/oab" -Confirm:$false
   $exchangeServers | Get-OwaVirtualDirectory | Set-OwaVirtualDirectory -ExternalUrl "$ExternalUrl/owa" -Confirm:$false
   $exchangeServers | Get-EcpVirtualDirectory | Set-EcpVirtualDirectory -ExternalUrl "$ExternalUrl/ecp" -Confirm:$false
   $exchangeServers | Get-MapiVirtualDirectory | Set-MapiVirtualDirectory -ExternalUrl "$ExternalUrl/ecp" -Confirm:$false
   $exchangeServers | Get-ActiveSyncVirtualDirectory | Set-ActiveSyncVirtualDirectory -ExternalUrl "$ExternalUrl/Microsoft-Server-ActiveSync" -Confirm:$false
}
 
if(($InternalUrl -ne "") -or ($ExternalUrl -ne "")) {
    # Query Settings
    Write-Output ""
    Write-Output "Current Url settings for CAS AutodiscoverServiceInternalUri"
    $exchangeServers | Get-ClientAccessServer | fl Identity, AutodiscoverServiceInternalUri
    Write-Output "Current Url settings for Web Services Virtual Directory"
    $exchangeServers | Get-WebServicesVirtualDirectory | fl Identity, InternalUrl, ExternalUrl
    Write-Output "Current Url settings for OAB Virtual Directory"
    $exchangeServers | Get-OabVirtualDirectory | fl Identity, InternalUrl, ExternalUrl
    Write-Output "Current Url settings for OWA Virtual Directory"
    $exchangeServers | Get-OwaVirtualDirectory | fl Identity, InternalUrl,ExternalUrl
    Write-Output "Current Url settings for ECP Virtual Directory"
    $exchangeServers | Get-EcpVirtualDirectory | fl Identity, InternalUrl,ExternalUrl
    Write-Output "Current Url settings for MAPI Virtual Directory"
    $exchangeServers | Get-MapiVirtualDirectory | fl Identity, InternalUrl,ExternalUrl
    Write-Output "Current Url settings for ActiveSync Virtual Directory"
    $exchangeServers | Get-ActiveSyncVirtualDirectory | fl Identity, internalurl, ExternalUrl
}
else {
    Write-Output "Nothing changed!"
}
