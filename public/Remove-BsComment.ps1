Function Remove-BsComment {
<#
    .SYNOPSIS
        Delete a single comment from the system.

    .DESCRIPTION
        Delete a single comment from the system.

    .PARAMETER Id
        The identifier of the comment

    .EXAMPLE
        Remove-BsComment -Id 13

    .FUNCTIONALITY
        DELETE: comments/{id}

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
            Write-Output (Invoke-BookStackQuery -UrlFunction "comments/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
