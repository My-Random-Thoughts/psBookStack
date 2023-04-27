Function New-BsUser {
<#
    .SYNOPSIS
        Create a new user in the system. Requires permission to manage users.

    .DESCRIPTION
        Create a new user in the system. Requires permission to manage users.

    .PARAMETER Name
        The name of the new user

    .PARAMETER Email
        The email address of the new user

    .PARAMETER ExternalAuthId
        The external authentication id of the new user

    .PARAMETER Language
        The language the new user will use

    .PARAMETER Password
        The password of the new user, passed as a secure string

    .PARAMETER RoleId
        The assigned role ids of the new user

    .PARAMETER SendInvite
        Option to send an invite to the new user

    .EXAMPLE
        New-BsUser -Name 'Bob Smith' -Email 'bob@example.com' -RoleId (1,2) -Language 'en' -Password ...

    .EXAMPLE
        New-BsUser -Name 'Bob Smith' -Email 'bob@example.com' -RoleId 4 -Language 'fr' -SendInvite

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateLength(2,100)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateLength(2,500)]
        [string]$Email,

        [string]$ExternalAuthId,

        [ValidateSet('ar','bg','bs','ca','cs','cy','da','de','de_informal','el','en','es','es_AR','et','eu','fa','fr','he','hr','hu','id','it','ja','ka','ko','lt','lv','nb','nl','pl','pt','pt_BR','ro','ru','sk','sl','sv','tr','uk','uz','vi','zh_CN','zh_TW')]
        [string]$Language = 'en',

        [Parameter(Mandatory = $true, ParameterSetName = 'password')]
        [securestring]$Password,

        [int[]]$RoleId,

        [Parameter(Mandatory = $true, ParameterSetName = 'invite')]
        [switch]$SendInvite
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            name = $Name
            email = $Email
            language = $Language
            send_invite = ($SendInvite.IsPresent)
        }

        If (-not $SendInvite.IsPresent) {
            $apiQuery += @{ password = (ConvertFrom-SecureString -SecureString $Password -AsPlainText)}
        }

        If ($ExternalAuthId) {
            $apiQuery += @{ external_auth_id = $ExternalAuthId }
        }

        If ($RoleId) {
            $apiQuery += @{ roles = $RoleId }
        }

        Write-Output $apiQuery
        Invoke-BookStackQuery -UrlFunction 'users' -RestMethod Post -ApiQuery $apiQuery
    }

    End {
    }
}
