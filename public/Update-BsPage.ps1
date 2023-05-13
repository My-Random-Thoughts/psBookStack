Function Update-BsPage {
<#
    .SYNOPSIS
        Update the details of a single page

    .DESCRIPTION
        Update the details of a single page

    .PARAMETER Id
        The id of the page to update

    .PARAMETER BookId
        The id of the book that holds this book.  Providing this property will essentially move the page into that parent element if you have permissions to do so

    .PARAMETER ChapterId
        The id of the chapter that holds this book.  Providing this property will essentially move the page into that parent element if you have permissions to do so

    .PARAMETER Name
        The new name of the page

    .PARAMETER Tags
        Any new tags to assign to new page

    .PARAMETER Html
        The new HTML contents of the page

    .PARAMETER Markdown
        The new Markdown contents of the page

    .EXAMPLE
        Update-BsPage -Id 12 -BookId 13 -Name 'The Next Page' -Html '<p>Hello World</p>'

    .EXAMPLE
        Update-BsPage -Id 23 ChapterId 13 -Name 'The New Page' Markdown '~~Hello World~~'

    .FUNCTIONALITY
        PUT: pages/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(ParameterSetName = 'book-html')]
        [Parameter(ParameterSetName = 'book-mark')]
        [int]$BookId,

        [Parameter(ParameterSetName = 'chap-html')]
        [Parameter(ParameterSetName = 'chap-mark')]
        [int]$ChapterId,

        [ValidateLength(1,255)]
        [string]$Name,

        [hashtable]$Tag,

        [Parameter(ParameterSetName = 'book-html')]
        [Parameter(ParameterSetName = 'chap-html')]
        [string]$Html,

        [Parameter(ParameterSetName = 'book-mark')]
        [Parameter(ParameterSetName = 'chap-mark')]
        [string]$Markdown
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        If ($BookId) {
            $apiQuery += @{ book_id = $BookId }
        }
        If ($ChapterId) {
            $apiQuery += @{ chapter_id = $ChapterId }
        }
        If ($Html) {
            $apiQuery += @{ html = $Html }
        }
        If ($Markdown) {
            $apiQuery += @{ markdown = $Markdown }
        }

        If ($Tag) {
            $bsTags = @()
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }
            $apiQuery += @{ tags = $bsTags }
        }

        Invoke-BookStackQuery -UrlFunction "pages/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}
