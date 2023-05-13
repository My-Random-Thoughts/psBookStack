Function Update-BsBook {
<#
    .SYNOPSIS
        Updates a book in the system

    .DESCRIPTION
        Updates a book in the system

    .PARAMETER Id
        The id of the book to update

    .PARAMETER Name
        The new name of the book

    .PARAMETER Description
        The new description of the book

    .PARAMETER Tags
        Any new tags to assign to the book

    .PARAMETER Image
        The cover image of the book

    .PARAMETER RemoveCoverImage
        Option to remove the current cover image

    .EXAMPLE
        Update-BsBook -Id 13 -Name 'My own book' -Description 'This is my own little book'

    .EXAMPLE
        Update-BsBook -Id 13 -Name 'My own book' -Tag @{Type = 'Book'; Topic = 'Testing'}

    .FUNCTIONALITY
        PUT: books/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [ValidateLength(0,255)]
        [string]$Name,

        [ValidateLength(0,1000)]
        [string]$Description,

        [hashtable]$Tag,

        [Parameter(ParameterSetName = 'addImage')]
        [System.IO.FileInfo]$CoverImage,

        [Parameter(ParameterSetName = 'delImage')]
        [switch]$RemoveCoverImage
    )

    Begin {
        If ($CoverImage) {
            If (-not (Test-Path -Path $CoverImage -PathType Leaf -Include ('*.jpg','*.jpeg','*.png','*.gif','*.webp'))) {
                Throw 'CoverImage file does not exist'
            }
        }
    }

    Process {
        $apiQuery = @{}

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        If ($Description) {
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
            Invoke-BookStackMultiPart -UrlFunction "books/$Id" -RestMethod Put -ApiQuery $apiQuery -Path $CoverImage
        }
        Else {
            If ($RemoveCoverImage.IsPresent) { $apiQuery += @{ image = $null }}
            Invoke-BookStackQuery -UrlFunction "books/$Id" -RestMethod Put -ApiQuery $apiQuery
        }
    }

    End {
    }
}