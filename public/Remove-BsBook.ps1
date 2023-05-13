Function Remove-BsBook {
<#
    .SYNOPSIS
        Delete a single book. This will typically send the book to the recycle bin

    .DESCRIPTION
        Delete a single book. This will typically send the book to the recycle bin

    .PARAMETER Id
        The identifier of the book

    .EXAMPLE
        Remove-BsBook -Id 13

    .FUNCTIONALITY
        DELETE: books/{id}

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
            Write-Output (Invoke-BookStackQuery -UrlFunction "books/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
