Function New-BsImageGallery {
<#
    .SYNOPSIS
        Create a new image in the system

    .DESCRIPTION
        Create a new image in the system

    .PARAMETER Type


    .PARAMETER Name


    .PARAMETER PageId


    .PARAMETER Image


    .EXAMPLE
        New-BsImageGallery

    .EXAMPLE
        New-BsImageGallery

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('gallery','drawio')]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [int]$PageId,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Image,

        [ValidateLength(0,100)]
        [string]$Name
    )

    Begin {
        [string[]]$allowedFileTypes = '*.jpg','*.jpeg','*.png','*.gif','*.webp'

        If ($Type -eq 'drawio') {
            $allowedFileTypes = '*.png'
        }

        If ($Image) {
            If (-not (Test-Path -Path $Image -PathType Leaf -Include $allowedFileTypes)) {
                Throw 'Image file does not exist'
            }
        }
    }

    Process {
        $apiQuery = @{
            type = $Type
            uploaded_to = $PageId
        }

        If ($Name) {
            $apiQuery += @{ name = $Name }
        }

        Return (Invoke-BookStackMultiPart -UrlFunction 'image-gallery' -RestMethod Post -ApiQuery $apiQuery -Path $Image)
     }

    End {
    }
}
