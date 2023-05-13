Function Export-BsBook {
<#
    .SYNOPSIS
        Export a book to the console

    .DESCRIPTION
        Export a book to the console, best used with 'Out-File' command to save in the required format

    .PARAMETER Id
        The identifier of the book

    .PARAMETER Format
        The format to export as.  One of html, pdf, plaintext, markdown

    .EXAMPLE
        Export-BsBook -Id 1 -Format pdf | Out-File -FilePath ...

    .EXAMPLE
        Export-BsBook -Id 13 -Format html | Out-File -FilePath ...

    .FUNCTIONALITY
        GET: books/{id}/export/html
        GET: books/{id}/export/pdf
        GET: books/{id}/export/plaintext
        GET: books/{id}/export/markdown

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('html', 'pdf', 'plaintext', 'markdown')]
        [string]$Format
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction "books/$id/export/$($Format.ToLower())" -RestMethod Get)
}
