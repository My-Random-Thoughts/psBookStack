Function Remove-BsUser {
<#
    .SYNOPSIS
        Delete a user from the system. Requires permission to manage roles

    .DESCRIPTION
        Delete a user from the system. Requires permission to manage roles

    .PARAMETER Id
        The identifier of the user

    .PARAMETER MigrateOwnershipId
        The identifier of the user who should be the new owner of their related content.

    .EXAMPLE
        Remove-BsUser -Id 13

    .EXAMPLE
        Remove-BsUser -Id 13 -MigrateOwnershipId 31

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Id,

        [int]$MigrateOwnershipId
    )

    Begin {
        $removeId = -1
    }

    Process {
        If ($Id -is [int]) {
            $removeId = $Id
        }
        ElseIf (($Id -is [object]) -and ($null -ne $Id.id)) {
            $removeId = $Id.id
        }

        If ($removeId -gt -1) {
            $apiQuery = @{}
            If ($MigrateOwnershipId) {
                $apiQuery = @{ migrate_ownership_id = $MigrateOwnershipId }
            }

            Write-Verbose -Message "Deleting: $removeId"
            Write-Output (Invoke-BookStackQuery -UrlFunction "users/$removeId" -RestMethod Delete -ApiQuery $apiQuery)
        }
    }

    End {
    }
}
