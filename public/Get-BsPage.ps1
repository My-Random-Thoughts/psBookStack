Function Get-BsPage {
<#
    .SYNOPSIS
        Get a listing of pages visible to the user, or view the details of a single page

    .DESCRIPTION
        Get a listing of pages visible to the user, or view the details of a single page

    .PARAMETER Id
        The identifier of the page

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsPage

    .EXAMPLE
        Get-BsPage -Id 13

    .EXAMPLE
        Get-BsPage -Filter '[id:lt]=10'

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
        Write-Output (Invoke-BookStackQuery -UrlFunction "pages/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "pages$parsedFilter" -RestMethod Get)
    }
}
