Function Complete-BsImport {
<#
    .SYNOPSIS
        Run the import process for an uploaded ZIP import.

    .DESCRIPTION
        Run the import process for an uploaded ZIP import.  On success, this endpoint returns the imported item.

    .PARAMETER Id
        The identifier of the import

    .PARAMETER ParentType
        The parent type to import too.  Required when the import type is "chapter" or "page".

    .PARAMETER ParentId
        The id of the parent to import too.  Required when the import type is "chapter" or "page".

    .EXAMPLE
        Complete-BsImport -Id 3

    .FUNCTIONALITY
        POST: imports/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [ValidateSet('book','chapter')]
        [string]$ParentType,

        [int]$ParentId
    )

    Begin {
        $import = (Get-BsImport -Id $Id)

        [object]$parent = $null
        If ($ParentType) {
            Try {
                If ($ParentType -eq 'book') {
                    $parent = (Get-BsBook -Id $ParentId)
                }
                Else {
                    $parent = (Get-BsChapter -Id $ParentId)
                }
            }
            Catch {
                Throw "ParentId is invalid for this parent type."
            }
        }

        If ($import.type -eq 'page') {
            If ((-not $ParentType) -or (-not $ParentId)) {
                Throw "Import $Id ($($import.name)) is a $($import.type).  You must specify a ParentType and ParentId"
            }
        }
        ElseIf ($import.type -eq 'chapter') {
            If ((-not $ParentType) -or (-not $ParentId)) {
                Throw "Import $Id ($($import.name)) is a $($import.type).  You must specify a ParentType and ParentId"
            }
            If ($ParentType -eq 'chapter') {
                Throw "You can't import a chapter into another chapter."
            }
        }
        ElseIf ($import.type -eq 'book') {
            If ($ParentType -eq 'book') {
                Throw "You can't import a book into another book."
            }
        }
    }

    Process {
        If ($ParentType) {
            $apiQuery = @{
                parent_type = $ParentType.ToLower()
                parent_id   = $ParentId
            }
        }

        Return (Invoke-BookStackQuery -UrlFunction "imports/$Id" -RestMethod Post -ApiQuery $apiQuery)
    }

    End {
    }
}