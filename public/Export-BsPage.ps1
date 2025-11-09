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

    .FUNCTIONALITY
        GET: pages/{id}/export/html
        GET: pages/{id}/export/pdf
        GET: pages/{id}/export/plaintext
        GET: pages/{id}/export/markdown
        GET: pages/{id}/export/zip

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
        [ValidateSet('html', 'pdf', 'plaintext', 'markdown', 'zip')]
        [string]$Format,

        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction "pages/$id/export/$($Format.ToLower())" -RestMethod Get -FileName $FileName)
}
