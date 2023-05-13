Function New-BsShelf {
<#
    .SYNOPSIS
        Create a new shelf in the system.

    .DESCRIPTION
        Create a new shelf in the system.

    .PARAMETER Name
        The name of the new shelf

    .PARAMETER Description
        The description of the new shelf

    .PARAMETER Books
        List of book ids to add to the new shelf

    .PARAMETER Tags
        Any tags to assign to the new shelf

    .PARAMETER CoverImage
        The cover image of the new shelf

    .EXAMPLE
        New-BsShelf -Name 'My shelf' -Description 'This is my shelf'

    .FUNCTIONALITY
        POST: shelves

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [ValidateLength(0,1000)]
        [string]$Description,

        [int[]]$Books,

        [hashtable]$Tag,

        [System.IO.FileInfo]$CoverImage
    )

    Begin {
        If ($CoverImage) {
            If (-not (Test-Path -Path $CoverImage -PathType Leaf -Include ('*.jpg','*.jpeg','*.png','*.gif','*.webp'))) {
                Throw 'CoverImage file does not exist'
            }
        }
    }

    Process {
        $apiQuery = @{
            name = $Name
        }

        If ($Description) {
            $apiQuery += @{ description = $Description }
        }

        If ($Books) {
            $apiQuery += @{ books = $Books }
        }

        If ($Tag) {
            $bsTags = @()
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }
            $apiQuery += @{ tags = $bsTags }
        }

        If ($CoverImage) {
            Return (Invoke-BookStackMultiPart -UrlFunction 'shelves' -RestMethod Post -ApiQuery $apiQuery -Path $CoverImage)
        }
        Else {
            Return (Invoke-BookStackQuery -UrlFunction 'shelves' -RestMethod Post -ApiQuery $apiQuery)
        }
    }

    End {
    }
}