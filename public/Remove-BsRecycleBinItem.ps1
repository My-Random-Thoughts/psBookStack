Function Remove-BsRecycleBinItem {
<#
    .SYNOPSIS
        Remove a single deletion from the recycle bin

    .DESCRIPTION
        Remove a single deletion from the recycle bin

    .PARAMETER Id
        The identifier of the deletion

    .EXAMPLE
        Remove-BsRecycleBinItem -Id 13

    .EXAMPLE
        Get-BsRecycleBinItem | Remove-BsRecycleBinItem

    .FUNCTIONALITY
        DELETE: recycle-bin/{deletionId}

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
            Write-Verbose -Message "Deleting: $removeId"
            Invoke-BookStackQuery -UrlFunction "recycle-bin/$removeId" -RestMethod Delete
        }
    }

    End {
    }
}