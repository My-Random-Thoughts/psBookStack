Function Get-BsImport {
<#
    .SYNOPSIS
        List existing ZIP imports visible to the user. Requires permission to import content.

    .DESCRIPTION
        List existing ZIP imports visible to the user. Requires permission to import content.

    .PARAMETER Id
        The identifier of the import

    .EXAMPLE
        Get-BsZipImport

    .EXAMPLE
        Get-BsZipImport -Id 3

    .FUNCTIONALITY
        GET: imports
        GET: imports/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [int]$Id
    )

    If ($Id) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "imports/$Id" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-BookStackQuery -UrlFunction 'imports' -RestMethod Get)
    }
}
