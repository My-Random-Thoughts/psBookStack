Function Get-BsChapter {
<#
    .SYNOPSIS
        Get a listing of chapters visible to the user, or view the details of a single chapter

    .DESCRIPTION
        Get a listing of chapters visible to the user, or view the details of a single chapter

    .PARAMETER Id
        The identifier of the chapter

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsChapter

    .EXAMPLE
        Get-BsChapter -Id 13

    .EXAMPLE
        Get-BsChapter -Filter '[id:lt]=10'

    .FUNCTIONALITY
        GET: chapters
        GET: chapters/{id}

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
        Write-Output (Invoke-BookStackQuery -UrlFunction "chapters/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "chapters$parsedFilter" -RestMethod Get)
    }
}
