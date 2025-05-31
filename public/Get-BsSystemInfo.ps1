Function Get-BsSystemInfo {
<#
    .SYNOPSIS
        Provides some high-level details of the BookStack system

    .DESCRIPTION
        Provides some high-level details of the BookStack system

    .EXAMPLE
        Get-BsSystemInfo

    .FUNCTIONALITY
        GET: system

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    Write-Output (Invoke-BookStackQuery -UrlFunction "system" -RestMethod Get)
}
