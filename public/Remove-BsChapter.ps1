Function Remove-BsChapter {
<#
    .SYNOPSIS
        Delete a single chapter. This will typically send the chapter to the recycle bin

    .DESCRIPTION
        Delete a single chapter. This will typically send the chapter to the recycle bin

    .PARAMETER Id
        The identifier of the chapter

    .EXAMPLE
        Remove-BsChapter -Id 13

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
            Write-Output (Invoke-BookStackQuery -UrlFunction "chapters/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
