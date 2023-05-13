Function Update-BsUser {
<#
    .SYNOPSIS
        Update an existing user in the system. Requires permission to manage users

    .DESCRIPTION
        Update an existing user in the system. Requires permission to manage users

    .PARAMETER Id
        The id of the user to update

    .PARAMETER Name
        The new name of the user

    .PARAMETER Email
        The new email address of the user

    .PARAMETER ExternalAuthId
        The new external authentication id of the user

    .PARAMETER Language
        The language the new user will use

    .PARAMETER Password
        The new password of the user, passed as a secure string

    .PARAMETER RoleId
        The assigned role ids of the user

    .EXAMPLE
        New-BsUser -Id 13 -Email 'bob.smith@example.com'

    .EXAMPLE
        New-BsUser -Id 13 -Name 'Bob Smith' -Language 'gb'

    .FUNCTIONALITY
        PUT: users/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [ValidateLength(2,100)]
        [string]$Name,

        [ValidateLength(2,500)]
        [string]$Email,

        [string]$ExternalAuthId,

        [ValidateSet('ar','bg','bs','ca','cs','cy','da','de','de_informal','el','en','es','es_AR','et','eu','fa','fr','he','hr','hu','id','it','ja','ka','ko','lt','lv','nb','nl','pl','pt','pt_BR','ro','ru','sk','sl','sv','tr','uk','uz','vi','zh_CN','zh_TW')]
        [string]$Language = 'en',

        [securestring]$Password,

        [int[]]$RoleId
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        If ($Email) {
            $apiQuery += @{ email = $Email }
        }

        If ($Language) {
            $apiQuery += @{ language = $Language }
        }

        If ($ExternalAuthId) {
            $apiQuery += @{ external_auth_id = $ExternalAuthId }
        }

        If ($Password) {
            $apiQuery += @{ password = $Password }
        }

        If ($RoleId) {
            $apiQuery += @{ roles = $RoleId }
        }

        Invoke-BookStackQuery -UrlFunction "users/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}
