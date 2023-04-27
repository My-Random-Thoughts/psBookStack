Function Remove-BsRole {
<#
    .SYNOPSIS
        Delete a role from the system. Requires permission to manage roles

    .DESCRIPTION
        Delete a role from the system. Requires permission to manage roles

    .PARAMETER Id
        The identifier of the role

    .EXAMPLE
        Remove-BsRole -Id 13

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
            Write-Output (Invoke-BookStackQuery -UrlFunction "roles/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
