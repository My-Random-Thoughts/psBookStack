Function Get-BsBook {
<#
    .SYNOPSIS
        Get a listing of books visible to the user, or view the details of a single book

    .DESCRIPTION
        Get a listing of books visible to the user, or view the details of a single book

    .PARAMETER Id
        The identifier of the book

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsBook

    .EXAMPLE
        Get-BsBook -Id 13

    .EXAMPLE
        Get-BsBook -Filter '[id:lt]=10'

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
        Write-Output (Invoke-BookStackQuery -UrlFunction "books/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "books$parsedFilter" -RestMethod Get)
    }
}
