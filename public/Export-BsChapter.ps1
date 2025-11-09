Function Export-BsChapter {
<#
    .SYNOPSIS
        Export a chapter to the console

    .DESCRIPTION
        Export a chapter to the console, best used with 'Out-File' command to save in the required format

    .PARAMETER Id
        The identifier of the chapter

    .PARAMETER Format
        The format to export as.  One of html, pdf, plaintext, markdown

    .EXAMPLE
        Export-BsChapter -Id 1 -Format pdf | Out-File -FilePath ...

    .EXAMPLE
        Export-BsChapter -Id 13 -Format html | Out-File -FilePath ...

    .FUNCTIONALITY
        GET: chapters/{id}/export/html
        GET: chapters/{id}/export/pdf
        GET: chapters/{id}/export/plaintext
        GET: chapters/{id}/export/markdown
        GET: chapters/{id}/export/zip

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
        [ValidateSet('html', 'pdf', 'plaintext', 'markdown', 'zip')]
        [string]$Format,

        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction "chapters/$id/export/$($Format.ToLower())" -RestMethod Get -FileName $FileName)
}
