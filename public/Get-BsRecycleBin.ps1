Function Get-BsRecycleBin {
<#
    .SYNOPSIS
        Get a top-level listing of the items in the recycle bin

    .DESCRIPTION
        Get a top-level listing of the items in the recycle bin

    .PARAMETER ShowStatistics
        x

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsRecycleBin

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(ParameterSetName = 'id')]
        [switch]$ShowStatistics,

        [Parameter(ParameterSetName = 'filter')]
        [string]$Filter
    )

    If ($Filter) { $parsedFilter = "?filter$Filter" }
    $recycleBin = (Invoke-BookStackQuery -UrlFunction "recycle-bin$parsedFilter" -RestMethod Get)

    If ($ShowStatistics.IsPresent) {
        $statistics = [pscustomobject]@{
            'Shelves'  = 0
            'Chapters' = 0
            'Books'    = 0
            'Pages'    = 0
        }

        ForEach($item In $recycleBin) {
            Switch ($item.deletable_type) {
                'bookshelf'  {
                    $statistics.Shelves += $item.deletable.Count
                    Break
                }

                'chapter' {
                    ForEach ($chap In $item.deletable) {
                        $statistics.Pages += $chap.pages_count
                    }
                    Break
                }

                'book'    {
                    $statistics.Books += $item.deletable.Count
                    ForEach ($book In $item.deletable) {
                        $statistics.Pages += $book.pages_count
                        $statistics.Chapters += $book.chapters_count
                    }
                    Break
                }
            }
        }

        Return $statistics
    }
    Else {
        Return $recycleBin
    }
}
