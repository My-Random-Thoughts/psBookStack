Function Update-BsComment {
<#
    .SYNOPSIS
        Update the content or archived status of an existing comment.

    .DESCRIPTION
        Update the content or archived status of an existing comment.

    .PARAMETER Id
        The id of the comment to update

    .PARAMETER Html
        The new HTML contents of the comment

    .PARAMETER Archive
        Switch to archive or unacrhive the comment

    .EXAMPLE
        Update-BsComment -Id 12 -Html '<p>Hello World</p>'

    .EXAMPLE
        Update-BsComment -Id 23 -Archive $false

    .FUNCTIONALITY
        PUT: comments/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [string]$Html,

        [ValidateSet('true','false')]
        [string]$Archive
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($Html) {
            $apiQuery += @{ html = $Html }
        }

        If ($Archive -eq 'true')  { $apiQuery += @{ archived = $true  }}
        If ($Archive -eq 'false') { $apiQuery += @{ archived = $false }}

        Invoke-BookStackQuery -UrlFunction "comments/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}
