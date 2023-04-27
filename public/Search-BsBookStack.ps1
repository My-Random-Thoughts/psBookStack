Function Search-BsBookStack {
<#
    .SYNOPSIS
        Run a search query against all main content types (shelves, books, chapters & pages) in the system

    .DESCRIPTION
        Run a search query against all main content types (shelves, books, chapters & pages) in the system

    .PARAMETER query
        The search query to use. See https://www.bookstackapp.com/docs/user/searching/ for more information

    .EXAMPLE
        Search-BsBookStack -Query 'cats+{created_by:me}'

    .EXAMPLE
        Search-BsBookStack -Query '"london meeting"'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Query
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction "search?query=$Query" -RestMethod Get)
}
