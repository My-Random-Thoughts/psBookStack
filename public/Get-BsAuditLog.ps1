Function Get-BsAuditLog {
<#
    .SYNOPSIS
        Get a listing of audit log events in the system.

    .DESCRIPTION
        Get a listing of audit log events in the system. The loggable relation fields currently only relates to core content types (page, book, bookshelf, chapter) but this may be used more in the future across other types. Requires permission to manage both users and system settings.

    .EXAMPLE
        Get-BsAuditLog

    .FUNCTIONALITY
        GET: audit-log

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    Param (
    )

    Write-Output (Invoke-BookStackQuery -UrlFunction 'audit-log' -RestMethod Get)
}
