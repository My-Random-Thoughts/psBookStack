Function Restore-BsRecycleBinItem {
<#
    .SYNOPSIS
        Restore a single deletion from the recycle bin. Requires permission to manage both system settings and permissions

    .DESCRIPTION
        Restore a single deletion from the recycle bin. Requires permission to manage both system settings and permissions

    .PARAMETER Id
        The id of the deletion

    .EXAMPLE
        Restore-BsRecycleBinItem -Id 13

    .EXAMPLE
        Get-BsRecycleBinItem | Restore-BsRecycleBinItem

    .FUNCTIONALITY
        PUT: recycle-bin/{deletionId}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Id
    )

    Begin {
        $restoreId = -1
    }

    Process {
        If ($Id -is [int]) {
            $restoreId = $Id
        }
        ElseIf (($Id -is [object])-and ($null -ne $Id.id)) {
            $restoreId = $Id.id
        }

        if ($restoreId -gt -1) {
            Write-Verbose -Message "Restoring: $restoreId"
            Invoke-BookStackQuery -UrlFunction "recycle-bin/$restoreId" -RestMethod Put
        }
    }

    End {
    }
}