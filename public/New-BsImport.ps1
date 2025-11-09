Function New-BsImport {
<#
    .SYNOPSIS
        Start a new import from a ZIP file.

    .DESCRIPTION
        Start a new import from a ZIP file. This does not actually run the import. This uploads, validates and stores the ZIP file so it's ready to be imported.

    .PARAMETER FileName
        The filename of a BookStack-compatible ZIP file.

    .EXAMPLE
        New-BsImport -FileName '~/bookstack.zip'

    .FUNCTIONALITY
        POST: imports

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    Param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$FileName
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            file = $FileName
        }

        Return (Invoke-BookStackMultiPart -UrlFunction 'imports' -RestMethod Post -ApiQuery $apiQuery -Path $FileName)
    }

    End {
    }
}