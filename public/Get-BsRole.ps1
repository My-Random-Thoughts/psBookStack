Function Get-BsRole {
<#
    .SYNOPSIS
        Get a listing of roles in the system, or or view the details of a single role. Requires permission to manage roles

    .DESCRIPTION
        Get a listing of roles in the system, or or view the details of a single role. Requires permission to manage roles

    .PARAMETER Id
        The identifier of the role

    .EXAMPLE
        Get-BsRole

    .EXAMPLE
        Get-BsRole -Id 13

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    Param (
        [int]$Id
    )

    If ($Id) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "roles/$Id" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-BookStackQuery -UrlFunction 'roles' -RestMethod Get)
    }
}
