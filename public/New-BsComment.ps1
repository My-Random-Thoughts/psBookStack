Function New-BsComment {
<#
    .SYNOPSIS
        Create a new comment on a page.

    .DESCRIPTION
        Create a new comment on a page, optionaly replying to and exiting comment.

    .PARAMETER PageId
        The id of the page to comment on.

    .PARAMETER ReplyTo
        The id of the comment to reply too, if required.

    .PARAMETER Html
        The HTML of the new comment, supports: <strong>, <em>, <a>, <ul>, and <ol>

    .EXAMPLE
        New-BsComment -PageId 13 -Html '<p>This is a great guide!</p>'

    .EXAMPLE
        New-BsComment -PageId 13 -ReplyTo 7 -Html '<p>I agree.  Well done.</p>'

    .FUNCTIONALITY
        POST: comments

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$PageId,

        [int]$ReplyTo,

        [Parameter(Mandatory = $true)]
        [string]$Html
    )

    Begin {
        If ($ReplyTo) {
            $comment = (Get-BsComment -Id $ReplyTo)
            If (-not $comment) {
                Throw 'Invalid ReplyTo id, that comment does not exist.'
            }
        }
    }

    Process {
        $apiQuery = @{
            page_id = $PageId
            html    = $Html
        }

        If ($ReplyTo) {
            $apiQuery += @{ reply_to = $ReplyTo }
        }

        Invoke-BookStackQuery -UrlFunction 'comments' -RestMethod Post -ApiQuery $apiQuery
    }

    End {
    }
}
