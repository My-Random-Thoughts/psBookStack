Function New-BsPage {
<#
    .SYNOPSIS
        Create a new page in the system

    .DESCRIPTION
        Create a new page in the system

    .PARAMETER BookId
        The id of the book that holds this book

    .PARAMETER ChapterId
        The id of the chapter that holds this book

    .PARAMETER Name
        The name of the new page

    .PARAMETER Tags
        Any tags to assign to the new page

    .PARAMETER Html
        The HTML contents of the new page

    .PARAMETER Markdown
        The Markdown contents of the new page

    .EXAMPLE
        New-BsPage -BookId 13 -Name 'The Next Page' -Html '<p>Hello World</p>'

    .EXAMPLE
        New-BsPage ChapterId 13 -Name 'The New Page' Markdown '~~Hello World~~'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'book-html')]
        [Parameter(Mandatory = $true, ParameterSetName = 'book-mark')]
        [int]$BookId,

        [Parameter(Mandatory = $true, ParameterSetName = 'chap-html')]
        [Parameter(Mandatory = $true, ParameterSetName = 'chap-mark')]
        [int]$ChapterId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [hashtable]$Tag,

        [Parameter(Mandatory = $true, ParameterSetName = 'book-html')]
        [Parameter(Mandatory = $true, ParameterSetName = 'chap-html')]
        [string]$Html,

        [Parameter(Mandatory = $true, ParameterSetName = 'book-mark')]
        [Parameter(Mandatory = $true, ParameterSetName = 'chap-mark')]
        [string]$Markdown
    )

    Begin {
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'book-html' {
                $apiQuery = @{
                    name    = $Name
                    html    = $Html
                    book_id = $BookId
                }
            }

            'chap-html' {
                $apiQuery = @{
                    name       = $Name
                    html       = $Html
                    chapter_id = $ChapterId
                }
            }

            'book-mark' {
                $apiQuery = @{
                    name     = $Name
                    markdown = $Markdown
                    book_id  = $BookId
                }
            }

            'chap-mark' {
                $apiQuery = @{
                    name       = $Name
                    markdown   = $Markdown
                    chapter_id = $ChapterId
                }
            }
        }

        If ($Tag) {
            $bsTags = @()
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }
            $apiQuery += @{ tags = $bsTags }
        }

        Invoke-BookStackQuery -UrlFunction 'pages' -RestMethod Post -ApiQuery $apiQuery
    }

    End {
    }
}
