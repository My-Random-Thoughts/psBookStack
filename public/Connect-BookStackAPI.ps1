Function Connect-BookStackAPI {
<#
    .SYNOPSIS
        Creates a new authentication session to BookStack

    .DESCRIPTION
        Creates a new authentication session to BookStack

    .PARAMETER Url
        The full URL of the BookStack instance

    .PARAMETER Credential
        Credential object containing token id as the username and token secret as the password

    .PARAMETER Token
        String containing the token string in the format (token_id):(token_secret)

    .EXAMPLE
        Connect-BookStackAPI -HostName http://1.2.3.4:81 -Credential (Get-Credential)

    .EXAMPLE
        Connect-BookStackAPI -HostName https://10.1.2.3:443 -Token abcde:12345

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(SupportsShouldProcess)]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope = 'Function')]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $true, ParameterSetName = 'Cred')]
        [pscredential]$Credential,

        [Parameter(Mandatory = $true, ParameterSetName = 'Token')]
        [string]$Token
    )

    Begin {
        $Url = $Url.TrimEnd('/')

        $invokeWebRequest = @{
            ErrorAction = 'Stop'
        }
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Url)) {
            $global:BookStackSession = $null

            If ($Credential) {
                [string]$username = $Credential.UserName
                [string]$securepw = (ConvertFrom-SecureString -SecureString $Credential.Password)
                [string]$password = (New-Object System.Net.NetworkCredential('Null', $(ConvertTo-SecureString -String $securepw), 'Null')).Password
            }
            Else {
                [string]$username = $Token.Split(':')[0]
                [string]$password = $Token.Split(':')[1]
            }

            $invokeWebRequest += @{
                Uri     = "$Url/api/shelves"
                Method  = 'Get'
                Headers = @{Authorization = ('Token {0}:{1}' -f $username, $password)}
            }

            $iWebReq = (Invoke-WebRequest @invokeWebRequest -SessionVariable global:BookStackSession )

            # Add extra header information
            $global:BookStackSession.Headers.Add('Url',  $Url)

            Write-Output "Connection Status: $($iWebReq.statusCode) $($iWebReq.statusDescription)"
        }
    }

    End {
    }
}
