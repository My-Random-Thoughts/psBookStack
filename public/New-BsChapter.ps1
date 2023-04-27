Function New-BsChapter {
<#
    .SYNOPSIS
        Create a new chapter in the system

    .DESCRIPTION
        Create a new chapter in the system

    .PARAMETER BookId
        The id of the book that holds this chapter

    .PARAMETER Name
        The name of the new chapter

    .PARAMETER Description
        The description of the new chapter

    .PARAMETER Tags
        Any tags to assign to the new chapter

    .EXAMPLE
        New-BsChapter -BookId 13 -Name 'My New Chapter'

    .EXAMPLE
        New-BsChapter -BookId 13 -Name 'My New Chapter' -Tag @{'Topic'='Testing'}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$BookId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [ValidateLength(0,1000)]
        [string]$Description,

        [hashtable]$Tag
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            book_id = $BookId
            name = $Name
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

        Invoke-BookStackQuery -UrlFunction 'chapters' -RestMethod Post -ApiQuery $apiQuery
    }

    End {
    }
}
