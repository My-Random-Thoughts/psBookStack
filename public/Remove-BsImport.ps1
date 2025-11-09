Function Remove-BsImport {
<#
    .SYNOPSIS
        Delete a pending ZIP import from the system.

    .DESCRIPTION
        Delete a pending ZIP import from the system.

    .PARAMETER Id
        The identifier of the import

    .EXAMPLE
        Remove-BsImport -Id 13

    .FUNCTIONALITY
        DELETE: imports/{id}

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
            Write-Output (Invoke-BookStackQuery -UrlFunction "imports/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
