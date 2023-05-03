Function Update-BsPermission {
<#
    .SYNOPSIS
        Update the configured content-level permission overrides for the item of the given type and ID

    .DESCRIPTION
        Update the configured content-level permission overrides for the item of the given type and ID

    .PARAMETER ContentType
        Specifies a type of the content to get.  Options are 'page','book','chapter','bookshelf'

    .PARAMETER Id
        The identifier of the content

    .PARAMETER OwnerId
        The identifier of the owner to assign the content to

    .PARAMETER RolePermission
        Permissions to assign to the content, must include all options (view, create, update, delete)

    .PARAMETER RemoveRolePermission
        Option to remove all current role permissions

    .PARAMETER FallbackPermission
        Specifies any fallback permissions

    .EXAMPLE
        Update-BsPermission -ContentType 'book' -Id 13 -RolePermission @{role_id=14; view=$true; create=$false; update=$false; delete=$false;}

    .EXAMPLE
        Update-BsPermission -ContentType 'book' -Id 13 -OwnerId 7 -RemoveRolePermissions

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('page','book','chapter','bookshelf')]
        [string]$ContentType,

        [Parameter(Mandatory = $true)]
        [int]$Id,

        [int]$OwnerId,

        [Parameter(ParameterSetName = 'setRole')]
        [hashtable[]]$RolePermission,

        [Parameter(ParameterSetName = 'delRole')]
        [switch]$RemoveRolePermission,

        [hashtable[]]$FallbackPermission
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($OwnerId) {
            $apiQuery += @{ owner_id = $OwnerId }
        }

        If ($RolePermission) {
            $apiQuery += @{ role_permissions = $RolePermission }
        }

        If ($RemoveRolePermission.IsPresent) {
            $apiQuery += @{ role_permissions = @() }
        }

        If ($FallbackPermission) {
            $apiQuery += @{ fallback_permissions = $FallbackPermission }
        }

        Invoke-BookStackQuery -UrlFunction "content-permissions/$($ContentType.ToLower())/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}
