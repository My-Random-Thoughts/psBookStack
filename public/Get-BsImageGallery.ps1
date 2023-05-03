Function Get-BsImageGallery {
<#
    .SYNOPSIS
        Get a listing of images in the system, or view the details of a single image

    .DESCRIPTION
        Get a listing of images in the system, or view the details of a single image

    .PARAMETER Id
        The identifier of the image

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .EXAMPLE
        Get-BsImageGallery

    .EXAMPLE
        Get-BsImageGallery -Id 13

    .EXAMPLE
        Get-BsPage -Filter '[id:lt]=10'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(ParameterSetName = 'id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'filter')]
        [string]$Filter
    )

    If ($Id) {
        Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery/$Id" -RestMethod Get)
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery$parsedFilter" -RestMethod Get)
    }
}
