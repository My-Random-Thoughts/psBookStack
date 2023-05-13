Function Get-BsPermission {
<#
    .SYNOPSIS
        Read the configured content-level permissions for the item of the given type and ID

    .DESCRIPTION
        Read the configured content-level permissions for the item of the given type and ID

    .PARAMETER ContentType
        Specifies a type of the content to get.  Options are 'page','book','chapter','bookshelf'

    .PARAMETER Id
        The identifier of the content

    .EXAMPLE
        Get-BsPermission -ContentType 'page' -Id 13

    .EXAMPLE
        Get-BsPermission -ContentType 'bookshelf' -Id 13

    .FUNCTIONALITY
        GET: content-permissions/{contentType}/{contentId}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('page','book','chapter','bookshelf')]
        [string]$ContentType,

        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction "content-permissions/$($ContentType.ToLower())/$Id" -RestMethod Get)
}
