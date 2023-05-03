Function Remove-BsImageGallery {
<#
    .SYNOPSIS
        Delete an image from the system. Will also delete thumbnails for the image. Does not check or handle image usage so this could leave pages with broken image references

    .DESCRIPTION
        Delete an image from the system. Will also delete thumbnails for the image. Does not check or handle image usage so this could leave pages with broken image references

    .PARAMETER Id
        The identifier of the image

    .EXAMPLE
        Remove-BsImageGallery -Id 13

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Id
    )

    Begin {
        $removeId = -1
    }

    Process {
        If ($Id -is [int]) {
            $removeId = $Id
        }
        ElseIf (($Id -is [object]) -and ($null -ne $Id.id)) {
            $removeId = $Id.id
        }

        If ($removeId -gt -1) {
            Write-Verbose -Message "Deleting: $removeId"
            Write-Output (Invoke-BookStackQuery -UrlFunction "image-gallery/$removeId" -RestMethod Delete)
        }
    }

    End {
    }
}
