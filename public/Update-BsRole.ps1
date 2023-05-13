Function Update-BsRole {
<#
    .SYNOPSIS
        Update an existing role in the system. Requires permission to manage roles

    .DESCRIPTION
        Update an existing role in the system. Requires permission to manage roles

    .PARAMETER Id
        The id of the role to update

    .PARAMETER Name
        The new name of the role

    .PARAMETER Description
        A new description for the role

    .PARAMETER MfaEnforced
        Is Multi-Factor Authentication enforced for the role

    .PARAMETER RemoveMfaEnforcement
        Remove Multi-Factor Authentication enforcement from this role

    .PARAMETER ExternalAuthId
        The external authentication Id for the role

    .PARAMETER Permission
        Array of allow permissions for the role

    .EXAMPLE
        Update-BsRole -Id 13 -Description 'API Access Only'

    .EXAMPLE
        Update-BsRole -Id 13 -Permission ('restrictions-manage-own','access-api','content-export')

    .FUNCTIONALITY
        Put: roles/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [int]$Id,

        [ValidateLength(3,180)]
        [string]$Name,

        [ValidateLength(0,180)]
        [string]$Description,

        [Parameter(ParameterSetName = 'addMFA')]
        [switch]$MfaEnforced,

        [Parameter(ParameterSetName = 'delMFA')]
        [switch]$RemoveMfaEnforcement,

        [string]$ExternalAuthId,

        [ValidateSet('restrictions-manage-all','restrictions-manage-own','templates-manage','access-api','content-export','editor-change','settings-manage','users-manage','user-roles-manage','bookshelf-create-all','bookshelf-view-own','bookshelf-view-all','bookshelf-update-own','bookshelf-update-all','bookshelf-delete-own','bookshelf-delete-all','book-create-all','book-view-own','book-view-all','book-update-own','book-update-all','book-delete-own','book-delete-all','chapter-create-own','chapter-create-all','chapter-view-own','chapter-view-all','chapter-update-own','chapter-update-all','chapter-delete-own','chapter-delete-all','page-create-own','page-create-all','page-view-own','page-view-all','page-update-own','page-update-all','page-delete-own','page-delete-all','image-create-all','image-update-own','image-update-all','image-delete-own','image-delete-all','attachment-create-all','attachment-update-own','attachment-update-all','attachment-delete-own','attachment-delete-all','comment-create-all','comment-update-own','comment-update-all','comment-delete-own','comment-delete-all')]
        [string[]]$Permission
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($Name) {
            $apiQuery = @{ display_name = $Name }
        }

        If ($Description) {
            $apiQuery += @{ description = $Description }
        }

        If ($ExternalAuthId) {
            $apiQuery += @{ external_auth_id = $ExternalAuthId }
        }

        If ($MfaEnforced.IsPresent) {
            $apiQuery += @{ mfa_enforced = $true }
        }

        If ($RemoveMfaEnforcement.IsPresent) {
            $apiQuery += @{ mfa_enforced = $false }
        }

        If ($Permission.Count -gt 0) {
            $apiQuery += @{ permissions = $Permission }
        }

        Write-Output (ConvertTo-Json -InputObject $apiQuery -Depth 10)
        Invoke-BookStackQuery -UrlFunction "roles/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}