Function New-BsRole {
<#
    .SYNOPSIS
        Create a new role in the system. Requires permission to manage roles

    .DESCRIPTION
        Create a new role in the system. Requires permission to manage roles

    .PARAMETER Name
        The name of the new role

    .PARAMETER Description
        A description for the new role

    .PARAMETER MfaEnforced
        Is Multi-Factor Authentication enforced for the new role

    .PARAMETER ExternalAuthId
        The external authentication Id for the new role

    .PARAMETER Permission
        Array of allow permissions for the new role

    .EXAMPLE
        New-BsRole -Name 'API' -Description 'API Access Only' -Permission ('access-api')

    .EXAMPLE
        New-BsRole -Name 'New Role' -Permission ('restrictions-manage-own','access-api','content-export')

    .FUNCTIONALITY
        POST: roles

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateLength(3,180)]
        [string]$Name,

        [ValidateLength(0,180)]
        [string]$Description,

        [switch]$MfaEnforced,

        [string]$ExternalAuthId,

        [ValidateSet('restrictions-manage-all','restrictions-manage-own','templates-manage','access-api','content-export','editor-change','settings-manage','users-manage','user-roles-manage','bookshelf-create-all','bookshelf-view-own','bookshelf-view-all','bookshelf-update-own','bookshelf-update-all','bookshelf-delete-own','bookshelf-delete-all','book-create-all','book-view-own','book-view-all','book-update-own','book-update-all','book-delete-own','book-delete-all','chapter-create-own','chapter-create-all','chapter-view-own','chapter-view-all','chapter-update-own','chapter-update-all','chapter-delete-own','chapter-delete-all','page-create-own','page-create-all','page-view-own','page-view-all','page-update-own','page-update-all','page-delete-own','page-delete-all','image-create-all','image-update-own','image-update-all','image-delete-own','image-delete-all','attachment-create-all','attachment-update-own','attachment-update-all','attachment-delete-own','attachment-delete-all','comment-create-all','comment-update-own','comment-update-all','comment-delete-own','comment-delete-all')]
        [string[]]$Permission
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            display_name = $Name
            mfa_enforced = ($MfaEnforced.IsPresent)
        }

        If ($Description) {
            $apiQuery += @{ description = $Description }
        }

        If ($ExternalAuthId) {
            $apiQuery += @{ external_auth_id = $ExternalAuthId }
        }

        If ($Permission.Count -gt 0) {
            $apiQuery += @{ permissions = $Permission }
        }

        Write-Output (ConvertTo-Json -InputObject $apiQuery -Depth 10)
        Invoke-BookStackQuery -UrlFunction 'roles' -RestMethod Post -ApiQuery $apiQuery
    }

    End {
    }
}