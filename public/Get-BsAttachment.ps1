Function Get-BsAttachment {
<#
    .SYNOPSIS
        Get a listing of attachments visible to the user, or view the details of a single attachment

    .DESCRIPTION
        Get a listing of attachments visible to the user, or view the details of a single attachment

    .PARAMETER Id
        The identifier of the attachment

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsAttachment

    .EXAMPLE
        Get-BsAttachment -Id 13

    .EXAMPLE
        Get-BsAttachment -Filter '[id:lt]=10'

    .FUNCTIONALITY
        GET: attachments
        GET: attachments/{id}

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
        Write-Output (Invoke-BookStackQuery -UrlFunction "attachments/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "attachments$parsedFilter" -RestMethod Get)
    }
}
