Function Update-BsChapter {
<#
    .SYNOPSIS
        Update the details of a single chapter

    .DESCRIPTION
        Update the details of a single chapter

    .PARAMETER Id
        The id of the chapter to update

    .PARAMETER BookId
        The id of the book that holds this chapter

    .PARAMETER Name
        The new name of the chapter

    .PARAMETER Description
        The new description of the chapter

    .PARAMETER DescriptionHTML
        The new HTML description of the chapter, supports: <strong>, <em>, <a>, <ul>, and <ol>

    .PARAMETER Tags
        Any new tags to assign to the chapter

    .EXAMPLE
        Update-BsChapter -Id 13 -BookId 10

    .EXAMPLE
        Update-BsChapter -Id 13 -Name 'My Updated Chapter'

    .FUNCTIONALITY
        PUT: chapters/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [int]$BookId,

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
        $apiQuery = @{}

        If ($BookId) {
            $apiQuery += @{ book_id = $BookId }
        }

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        If ($Description) {
            $apiQuery += @{ description = $Description }
        }
        ElseIf ($DescriptionHTML) {
            $apiQuery += @{ description_html = $DescriptionHTML }
        }

        If ($Tag) {
            $bsTags = @()

            # Add all existing keys first...
            (Get-BsChapter -id $Id).tags | ForEach-Object {
                $bsTags += @{'name' = $_.name; 'value' = $_.value}
            }

            # Add new keys...
            ForEach ($TagKey In $Tag.Keys) {
                $bsTags += @{'name' = $TagKey; 'value' = $Tag.$TagKey}
            }

            $apiQuery += @{ tags = $bsTags }
        }

        Invoke-BookStackQuery -UrlFunction "chapters/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}
