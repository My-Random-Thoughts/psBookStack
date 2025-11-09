Function Get-BsImageGallery {
<#
    .SYNOPSIS
        Get a listing of images in the system, or view the details of a single image.

    .DESCRIPTION
        Get a listing of images in the system, or view the details of a single image.

    .PARAMETER Id
        The identifier of the image.

    .PARAMETER Url
        The url of the image.

    .PARAMETER FileName
        Specifies the filename to save the image too.

    .PARAMETER Filter
        Specifies a filter to help narrow down results.

    .EXAMPLE
        Get-BsImageGallery

    .EXAMPLE
        Get-BsImageGallery -Id 13

    .EXAMPLE
        Get-BsPage -Filter '[id:lt]=10'

    .FUNCTIONALITY
        GET: image-gallery
        GET: image-gallery/{id}
        GET: image-gallery/{id}/data
        GET: image-gallery/url/data

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(ParameterSetName = 'id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'url')]
        [string]$Url,

        [Parameter(ParameterSetName = 'id')]
        [Parameter(ParameterSetName = 'url')]
        [string]$FileName,

        [Parameter(ParameterSetName = 'filter')]
        [string]$Filter
    )

    If ($Id) {
        If ($FileName) {
            Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery/$Id/data" -RestMethod Get -FileName $FileName)
        }
        Else {
            Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery/$Id" -RestMethod Get)
        }
    }
    ElseIf ($Url) {
        If ($FileName) {
            [string]$parsedUrl = [System.Web.HttpUtility]::UrlEncode($Url)
            Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery/url/data?url=$parsedUrl" -RestMethod Get -FileName $FileName)
        }
        Else {
            Throw "The 'Url' parameter must be used with the 'FileName' parameter"
        }
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery$parsedFilter" -RestMethod Get)
    }
}
