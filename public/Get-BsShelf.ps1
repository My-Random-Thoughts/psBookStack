Function Get-BsShelf {
<#
    .SYNOPSIS
        Get a listing of shelves visible to the user, or view the details of a single shelf

    .DESCRIPTION
        Get a listing of shelves visible to the user, or view the details of a single shelf

    .PARAMETER Id
        The identifier of the shelf

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsShelf

    .EXAMPLE
        Get-BsShelf -Id 13

    .EXAMPLE
        Get-BsShelf -Filter '[id:lt]=10'

    .FUNCTIONALITY
        GET: shelves
        GET: shelves/{id}

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
        Write-Output (Invoke-BookStackQuery -UrlFunction "shelves/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "shelves$parsedFilter" -RestMethod Get)
    }
}
