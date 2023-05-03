Function New-BsImageGallery {
<#
    .SYNOPSIS
        Create a new image in the system

    .DESCRIPTION
        Create a new image in the system

    .PARAMETER Type
        Specifies the image type to create.  Either 'gallery' or 'drawio'.  'drawio' should only be used when the file is a PNG file with diagrams.net image data embedded within

    .PARAMETER PageId
        Specifies the page to assign the image to

    .PARAMETER Image
        Path to the file to upload

    .PARAMETER Name
        Specifies the name of the file.  If the parameter is omitted, the filename of the provided image file will be used instead

    .EXAMPLE
        New-BsImageGallery -Type 'gallery' -PageId 13 -Image '/media/file1.jpg'

    .EXAMPLE
        New-BsImageGallery -Type 'drawio' -PageId 13 -Image '/media/draw1.png' -Name 'Diagram 1'

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
