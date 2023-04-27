Function New-BsAttachment {
<#
    .SYNOPSIS
        Create a new attachment in the system

    .DESCRIPTION
        Create a new attachment in the system

    .PARAMETER PageId
        The id of the page that holds this attachment

    .PARAMETER Name
        The name of the new attachment

    .PARAMETER File
        Path to the file to upload

    .PARAMETER Link
        URL to link to

    .EXAMPLE
        New-BsAttachment -Id 13 -Name 'Presentation' -File c:\users\abc\presentation.odf'

    .EXAMPLE
        New-BsAttachment -Id 13 -Name 'Example Web Site' -Link 'http://www.example.com/'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$PageId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1,255)]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'file')]
        [string]$File,

        [Parameter(Mandatory = $true, ParameterSetName = 'link')]
        [ValidateLength(1,2000)]
        [string]$Link
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            uploaded_to = $PageId
            name = $Name
        }

        If ($File) {
            Invoke-BookStackMultiPart -UrlFunction 'attachments' -ApiQuery $apiQuery -RestMethod Post -Path $File
        }

        If ($Link) {
            $apiQuery += @{ link = $Link }
            Invoke-BookStackQuery -UrlFunction 'attachments' -RestMethod Post -ApiQuery $apiQuery
        }
    }

    End {
    }
}
