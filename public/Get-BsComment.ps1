Function Get-BsComment {
<#
    .SYNOPSIS
        Get a listing of comments visible to the user, or read the details of a single comment, along with its direct replies.

    .DESCRIPTION
        Get a listing of comments visible to the user, or read the details of a single comment, along with its direct replies.

    .PARAMETER Id
        The identifier of the comment

    .PARAMETER PageId
        The comments from a particular page

    .EXAMPLE
        Get-BsComment -Id 13

    .EXAMPLE
        Get-BsComment -PageId 42

    .FUNCTIONALITY
        GET: comments
        GET: comments/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(ParameterSetName = 'id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'pageid')]
        [int]$PageId
    )

    If ($Id) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "comments/$Id" -RestMethod Get)
    }
    ElseIf ($PageId) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "comments" -RestMethod Get | Where-Object { $_.commentable_id -eq $PageId })
    }
    Else {
        Write-Output (Invoke-BookStackQuery -UrlFunction "comments" -RestMethod Get)
    }
}
