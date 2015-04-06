<#
    .SYNOPSIS
    Configure Exchange Server 2013 Virtual Directory Url Settings
   
   	Thomas Stensitzki
	
	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
	Version 1.0, 2015-02-18

    Please send ideas, comments and suggestions to support@granikos.eu 
 
    .LINK  
    More information can be found at http://www.granikos.eu/en/scripts 
	
    .DESCRIPTION
	Exchange Server virtual directories (vDirs) require a proper configuration of
    internal and external Urls. This is even more important in a co-existence 
    scenario with legacy Exchange Server versions.

    Read more about Exchange Server 2013 vDirs at:
    http://blogs.technet.com/b/exchange/archive/2015/02/11/configuring-multiple-owa-ecp-virtual-directories-on-the-exchange-2013-client-access-server-role.aspx
    

    .NOTES 
    Requirements 
    - Windows Server 2008 R2 SP1, Windows Server 2012 or Windows Server 2012 R2
    - Exchange Server 2013

    Revision History 
    -------------------------------------------------------------------------------- 
    1.0     Initial community release 
	
	.PARAMETER InternalUrl
    The internal url FQDN with leading protocol definition, ie. https://mobile.mcsmemail.de

    .PARAMETER ExternalUrl
    The internal url FQDN with leading protocol definition, ie. https://mobile.mcsmemail.de
   
	.EXAMPLE
    Configure internal and external url for different host headers 
    .\Set-VirtualDirectoryUrl -InternalUrl https://internal.mcsmemail.de -ExternalUrl https://mobile.mcsmemail.de
	
#>

Param(
    [parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage='The internal Url host inclusive protocol, i.e. https://mobile.mcsmemail.de')]
        [string]$InternalUrl,  
    [parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage='The external Url host inclusive protocol, i.e. https://mobile.mcsmemail.de')]
        [string]$ExternalUrl  
)

Set-StrictMode -Version Latest

if($InternalUrl -ne "") {

    # Trim trailing "/"
    if($InternalUrl.EndsWith("/")) {
        $InternalUrl = $InternalUrl.TrimEnd('/')
    }

    # Fetch Exchange Server 2013 Servers with CAS role
    $exchangeServers = Get-ExchangeServer | Where {($_.IsE15OrLater -eq $true) -and ($_.ServerRole -ilike "*ClientAccess*")}
    Write-Output ""
    Write-Output "The following servers will be configured:"
    $exchangeServers | ft Name, AdminDisplayVersion -AutoSize

    Write-Output "Changing InternalUrl settings"
    Write-Output "New INTERNAL Url: $InternalUrl"
    
    $exchangeServers | Get-AutodiscoverVirtualDirectory | Set-AutodiscoverVirtualDirectory –InternalUrl “$InternalUrl/autodiscover/autodiscover.xml” 
    $exchangeServers | Set-ClientAccessServer –AutodiscoverServiceInternalUri “$InternalUrl/autodiscover/autodiscover.xml”
    $exchangeServers | Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory –InternalUrl “$InternalUrl/ews/exchange.asmx”
    $exchangeServers | Get-OabVirtualDirectory | Set-OabVirtualDirectory –InternalUrl “$InternalUrl/oab”
    $exchangeServers | Get-OwaVirtualDirectory | Set-OwaVirtualDirectory -InternalUrl “$InternalUrl/owa”
    $exchangeServers | Get-EcpVirtualDirectory | Set-EcpVirtualDirectory –InternalUrl “$InternalUrl/ecp”
    $exchangeServers | Get-ActiveSyncVirtualDirectory | Set-ActiveSyncVirtualDirectory -InternalUrl "$InternalUrl/Microsoft-Server-ActiveSync"
    
    Write-Output "InternalUrl changed"
}

if($ExternalUrl -ne "") {

    # Trim trailing "/"
    if($ExternalUrl.EndsWith("/")) {
        $ExternalUrl = $ExternalUrl.TrimEnd('/')
    }
    
    Write-Output "Changing ExternalUrl settings"
    Write-Output "New EXTERNAL Url: $ExternalUrl"

   $exchangeServers | Get-AutodiscoverVirtualDirectory | Set-AutodiscoverVirtualDirectory –ExternalUrl “$ExternalUrl/autodiscover/autodiscover.xml”
   $exchangeServers | Set-ClientAccessServer –AutodiscoverServiceInternalUri “$ExternalUrl/autodiscover/autodiscover.xml”
   $exchangeServers | Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory –ExternalUrl “$ExternalUrl/ews/exchange.asmx”
   $exchangeServers | Get-OabVirtualDirectory | Set-OabVirtualDirectory –ExternalUrl “$ExternalUrl/oab”
   $exchangeServers | Get-OwaVirtualDirectory | Set-OwaVirtualDirectory –ExternalUrl “$ExternalUrl/owa”
   $exchangeServers | Get-EcpVirtualDirectory | Set-EcpVirtualDirectory –ExternalUrl “$ExternalUrl/ecp”
   $exchangeServers | Get-ActiveSyncVirtualDirectory | Set-ActiveSyncVirtualDirectory -ExternalUrl "$ExternalUrl/Microsoft-Server-ActiveSync"
}
 
if(($InternalUrl -ne "") -or ($ExternalUrl -ne "")) {
    # Query Settings
    Write-Output ""
    Write-Output "Current Url settings for AutoD Virtual Directory"
    $exchangeServers | Get-AutodiscoverVirtualDirectory | fl Identity, InternalUrl, ExternalUrl 
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
    Write-Output "Current Url settings for ActiveSync Virtual Directory"
    $exchangeServers | Get-ActiveSyncVirtualDirectory | fl Identity, internalurl, ExternalUrl
}
else {
    Write-Output "Nothing changed!"
}
