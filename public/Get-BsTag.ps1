Function Get-BsTag {
<#
    .SYNOPSIS
        Get a list of tag names used in the system.

    .DESCRIPTION
        Get a list of tag names, or the values which have been set for the given tag name.

    .PARAMETER Name
        The name of the tag

    .EXAMPLE
        Get-BsTag

    .EXAMPLE
        Get-BsTag -Name 'Category'

    .FUNCTIONALITY
        GET: tags/names
        GET: tags/values-for-name

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [string]$Name
    )

    If ($Name) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "tags/values-for-name?name=$Name" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-BookStackQuery -UrlFunction "tags/names" -RestMethod Get)
    }
}
