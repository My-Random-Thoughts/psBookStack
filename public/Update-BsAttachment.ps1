Function Update-BsAttachment {
<#
    .SYNOPSIS
        Update the details of a single attachment

    .DESCRIPTION
        Update the details of a single attachment

    .PARAMETER Id
        The id of the attachment to update

    .PARAMETER PageId
        The id of the page that holds this attachment

    .PARAMETER Name
        The updated name of the attachment

    .PARAMETER File
        Path to the file to upload

    .PARAMETER Link
        URL to link to

    .FUNCTIONALITY
        PUT: attachments/{id}

    .EXAMPLE
        Update-BsAttachment -id 13 -PageId 27 -Name 'Presentation (2).odf'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [int]$PageId,

        [ValidateLength(1,255)]
        [string]$Name,

        [Parameter(ParameterSetName = 'file')]
        [string]$File,

        [Parameter(ParameterSetName = 'link')]
        [ValidateLength(1,2000)]
        [string]$Link
    )

    Begin {
    }

    Process {
        $apiQuery = @{}

        If ($PageId) {
            $apiQuery += @{ uploaded_to = $PageId }
        }

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        If ($File) {
            Invoke-BookStackMultiPart -UrlFunction "attachments/$Id" -RestMethod Put -ApiQuery $apiQuery -Path $File
        }
        Else {
            If ($link) { $apiQuery += @{ link = $Link }}
            Invoke-BookStackQuery -UrlFunction "attachments/$Id" -RestMethod Put -ApiQuery $apiQuery
        }
    }

    End {
    }
}