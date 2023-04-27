Function Get-BsUser {
<#
    .SYNOPSIS
        Get a listing of users in the system, or or view the details of a single user. Requires permission to manage users

    .DESCRIPTION
        Get a listing of users in the system, or or view the details of a single user. Requires permission to manage users

    .PARAMETER Id
        The identifier of the user

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsUser

    .EXAMPLE
        Get-BsUser -Id 13

    .EXAMPLE
        Get-BsUser -Filter '[id:lt]=10'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(ParameterSetName = 'id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'filter')]
        [string]$Filter
    )

    If ($Id) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "users/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "users$parsedFilter" -RestMethod Get)
    }
}
