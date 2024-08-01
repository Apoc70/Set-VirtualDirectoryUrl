# Set-VirtualDirectoryUrl

## Note

This repository is archived you can find the most recent release [here](https://github.com/Apoc70/PowerShell-Scripts/tree/main/Exchange%20Server/Set-VirtualDirectoryUrl).

## SYNOPSIS
    Configure Exchange Server 2013 Virtual Directory Url Settings

   	Thomas Stensitzki

	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

	Version 1.0, 2015-02-18

    Please send ideas, comments and suggestions to support@granikos.eu

## LINK
    More information can be found at http://www.granikos.eu/en/scripts

## DESCRIPTION
    Exchange Server virtual directories (vDirs) require a proper configuration of
    internal and external Urls. This is even more important in a co-existence
    scenario with legacy Exchange Server versions.

    Read more about Exchange Server 2013 vDirs at:
    http://blogs.technet.com/b/exchange/archive/2015/02/11/configuring-multiple-owa-ecp-virtual-directories-on-the-exchange-2013-client-access-server-role.aspx


## NOTES
    Requirements
    - Windows Server 2008 R2 SP1, Windows Server 2012 or Windows Server 2012 R2
    - Exchange Server 2013

    Revision History
    --------------------------------------------------------------------------------
    1.0     Initial community release

## PARAMETERS
### PARAMETER InternalUrl
    The internal url FQDN with leading protocol definition, ie. https://mobile.mcsmemail.de

### PARAMETER ExternalUrl
    The internal url FQDN with leading protocol definition, ie. https://mobile.mcsmemail.de

## EXAMPLE
    Configure internal and external url for different host headers
    .\Set-VirtualDirectoryUrl -InternalUrl https://internal.mcsmemail.de -ExternalUrl https://mobile.mcsmemail.de
