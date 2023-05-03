Function Update-BsImageGallery {
<#
    .SYNOPSIS
        Update the details of an existing image in the system. Only allows updating of the image name at this time

    .DESCRIPTION
        Update the details of an existing image in the system. Only allows updating of the image name at this time

    .PARAMETER Id
        The id of the image to update

    .PARAMETER Name
        The new name of the image

    .EXAMPLE
        Update-BsImageGallery -Id 13 -Name 'My own book'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateLength(0,180)]
        [string]$Name
    )

    Begin {
    }

    Process {
        $apiQuery = @{ name = $Name }
        Invoke-BookStackQuery -UrlFunction "image-gallery/$Id" -RestMethod Put -ApiQuery $apiQuery
    }

    End {
    }
}