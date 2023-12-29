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

    .PARAMETER DescriptionHTML
        The HTML description of the new chapter, supports: <strong>, <em>, <a>, <ul>, and <ol>

    .PARAMETER Tags
        Any tags to assign to the new chapter

    .EXAMPLE
        New-BsChapter -BookId 13 -Name 'My New Chapter'

    .EXAMPLE
        New-BsChapter -BookId 13 -Name 'My New Chapter' -Tag @{'Topic'='Testing'}

    .FUNCTIONALITY
        POST: chapters

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$BookId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [Parameter(ParameterSetName = 'nonHtmlDesc')]
        [ValidateLength(0,1000)]
        [string]$Description,

        [Parameter(ParameterSetName = 'htmlDesc')]
        [ValidateLength(0,2000)]
        [string]$DescriptionHTML,

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
        ElseIf ($DescriptionHTML) {
            $apiQuery += @{ description_html = $DescriptionHTML }
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
