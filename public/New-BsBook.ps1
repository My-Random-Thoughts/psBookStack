Function New-BsBook {
<#
    .SYNOPSIS
        Create a new book in the system

    .DESCRIPTION
        Create a new book in the system

    .PARAMETER ShelfId
        The id of the shelf to put it on

    .PARAMETER Name
        The name of the new book

    .PARAMETER Description
        The description of the new book

    .PARAMETER Tags
        Any tags to assign to the new book

    .PARAMETER CoverImage
        The cover image of the new book

    .EXAMPLE
        New-BsBook -ShelfId 13 -Name 'My own book' -Description 'This is my own little book'

    .EXAMPLE
        New-BsBook -ShelfId 13 -Name 'My own book' -Tag @{'Type'='Book'; 'Topic'='Testing'}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$ShelfId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [ValidateLength(0,1000)]
        [string]$Description,

        [hashtable]$Tag,

        [System.IO.FileInfo]$CoverImage
    )

    Begin {
        If ($CoverImage) {
            If (-not (Test-Path -Path $CoverImage -PathType Leaf -Include ('*.jpg','*.jpeg','*.png','*.gif','*.webp'))) {
                Throw 'CoverImage file does not exist'
            }
        }

        [object]$shelf = (Get-BsShelf -Id $ShelfId)
        If (-not $shelf) {
            Throw 'Invalid Shelf Id Given'
        }
        [int[]]$books = $shelf.books.id
    }

    Process {
        $apiQuery = @{
            name = $Name
        }

        if ($Description) {
            $apiQuery += @{ description = $Description }
        }

        If ($Tag) {
            $bsTags = @()
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }
            $apiQuery += @{ tags = $bsTags }
        }

        If ($CoverImage) {
            $result = (Invoke-BookStackMultiPart -UrlFunction 'books' -RestMethod Post -ApiQuery $apiQuery -Path $CoverImage)
        }
        Else {
            $result = (Invoke-BookStackQuery -UrlFunction 'books' -RestMethod Post -ApiQuery $apiQuery)
        }

        If ($result.id) {
            $books += $result.id
            [void](Update-BsShelf -Id $ShelfId -Books $books)
        }

        Return $result
    }

    End {
    }
}
