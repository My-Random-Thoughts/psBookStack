Function Export-BsPage {
<#
    .SYNOPSIS
        Export a page to the console

    .DESCRIPTION
        Export a page to the console, best used with 'Out-File' command to save in the required format

    .PARAMETER Id
        The identifier of the page

    .PARAMETER Format
        The format to export as.  One of html, pdf, plaintext, markdown

    .EXAMPLE
        Export-BsPage -Id 1 -Format pdf | Out-File -FilePath ...

    .EXAMPLE
        Export-BsPage -Id 13 -Format html | Out-File -FilePath ...

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psPageStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('html', 'pdf', 'plaintext', 'markdown')]
        [string]$Format
    )

    Write-Output (Invoke-PageStackQuery -UrlFunction "pages/$id/export/$($Format.ToLower())" -RestMethod Get)
}
