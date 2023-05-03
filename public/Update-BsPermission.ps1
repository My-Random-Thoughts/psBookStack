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

    .PARAMETER

    .PARAMETER

    .PARAMETER

    .PARAMETER

    .PARAMETER

    .EXAMPLE

    .EXAMPLE

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
