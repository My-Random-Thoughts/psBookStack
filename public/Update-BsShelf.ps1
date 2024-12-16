Function Update-BsShelf {
<#
    .SYNOPSIS
        Updates a shelf in the system.

    .DESCRIPTION
        Updates a shelf in the system.

    .PARAMETER Id
        The id of the shelf to update

    .PARAMETER Name
        The name of the shelf

    .PARAMETER Description
        The new description of the shelf

    .PARAMETER DescriptionHTML
        The new HTML description of the shelf, supports: <strong>, <em>, <a>, <ul>, and <ol>

    .PARAMETER Books
        The list of book IDs that this shelf contains. These will be added to the shelf in the same order as provided and overwrite any existing book assignments

    .PARAMETER Tags
        Any tags to assign to the shelf

    .PARAMETER Image
        The cover image of the shelf

    .PARAMETER RemoveCoverImage
        Option to remove the current cover image

    .EXAMPLE
        Update-BsShelf Id 13 -Name 'My updated shelf' -Books (11, 16)

    .EXAMPLE
        Update-BsShelf -Id 13 -RemoveCoverImage

    .FUNCTIONALITY
        PUT: shelves/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [ValidateLength(0,255)]
        [string]$Name,

        [Parameter(ParameterSetName = 'nonHtmlDesc')]
        [ValidateLength(0,1000)]
        [string]$Description,

        [Parameter(ParameterSetName = 'htmlDesc')]
        [ValidateLength(0,2000)]
        [string]$DescriptionHTML,

        [int[]]$Books,

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
        ElseIf ($DescriptionHTML) {
            $apiQuery += @{ description_html = $DescriptionHTML }
        }

        If ($Books) {
            $apiQuery += @{ books = $Books }
        }

        If ($Tag) {
            $bsTags = @()

            # Add all existing keys first...
            (Get-BsShelf -id $Id).tags | ForEach-Object {
                $bsTags += @{'name' = $_.name; 'value' = $_.value}
            }

            # Add new keys...
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }

            $apiQuery += @{ tags = $bsTags }
        }

        If ($CoverImage) {
            Invoke-BookStackMultiPart -UrlFunction "shelves/$Id" -RestMethod Put -ApiQuery $apiQuery -Path $CoverImage
        }
        Else {
            If ($RemoveCoverImage.IsPresent) { $apiQuery += @{ image = $null }}
            Invoke-BookStackQuery -UrlFunction "shelves/$Id" -RestMethod Put -ApiQuery $apiQuery
        }
    }

    End {
    }
}