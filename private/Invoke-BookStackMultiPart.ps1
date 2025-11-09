Function Invoke-BookStackMultiPart {
<#
    .SYNOPSIS
        Invokes MultiPart/Form-Data for BookStack

    .DESCRIPTION
        Helps to avoid code duplication in functions when calling the BookStack API

    .PARAMETER Uri
        Specifies the Uniform Resource Identifier (URI) of the internet resource to which the web request is sent

    .PARAMETER RestMethod
        Specifies the rest method used for the web request

    .PARAMETER ApiQuery
        Specifies the query to send for the web request

    .PARAMETER Path
        Specifies the path to the file to upload

    .EXAMPLE
        Invoke-BookStackRestMethod -Uri $Uri -Method 'Post'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/BookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
#        [ValidatePattern({^shelves*|^books*|^attachments*|^image-gallery*|^imports*})]
        [string]$UrlFunction,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$RestMethod,

        [Parameter(Mandatory = $true)]
        [hashtable]$ApiQuery,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )

    Begin {
        Add-Type -AssemblyName System.Net.Http

        $client   = New-Object -TypeName System.Net.Http.HttpClient
        $formData = New-Object -TypeName System.Net.Http.MultipartFormDataContent

        $client.BaseAddress = $($Global:BookStackSession.Headers.Url)
        $client.DefaultRequestHeaders.ConnectionClose = $true
        $client.DefaultRequestHeaders.Add('Authorization', $Global:BookStackSession.Headers.Authorization)
        If ($RestMethod -eq 'Put') {
            $client.DefaultRequestHeaders.Add('X-HTTP-Method-Override', 'PUT')
        }

        $fileStream = [System.IO.FileStream]::New($Path, [System.IO.FileMode]::Open)
#        If ($fileStream.Length -gt 50000) {
#             Throw "File size $($fileStream.Length) is greater than allowed limit 50000"
#        }
    }

    Process {
        Try {
            # Properties
            ForEach ($key In $apiQuery.Keys) {
                $formData.Add((New-Object -TypeName 'System.Net.Http.StringContent' ($apiQuery.$key)), $key)
            }

            # Cover Image / Attachment File
#            If (($UrlFunction -eq 'attachments') -or ($UrlFunction -eq 'imports')) { $attachmentName = 'file' } Else { $attachmentName = 'image' }
            $attachmentName = 'file'
            $formData.Add((New-Object -TypeName 'System.Net.Http.StreamContent' ($fileStream)), $attachmentName, $Path.Name)

            # Perform POST action
            $result = $client.PostAsync("/api/$($UrlFunction)", $formData)
            Write-Verbose -Message "Invoke-BookStackMultiPart: $($RestMethod) | $($UrlFunction) | $($result.Result.StatusCode)"

            If ($result.Result.StatusCode -ne 'OK') {
                Write-Error -Message $result.Result
            }
            Else {
                Switch -Regex ($UrlFunction) {
                    '^shelves*'       { Return (Get-BsShelf        -Verbose:$false | Sort-Object -Property 'id' | Select-Object -Last 1); Break }
                    '^books*'         { Return (Get-BsBook         -Verbose:$false | Sort-Object -Property 'id' | Select-Object -Last 1); Break }
                    '^attachments*'   { Return (Get-BsAttachment   -Verbose:$false | Sort-Object -Property 'id' | Select-Object -Last 1); Break }
                    '^image-gallery*' { Return (Get-BsImageGallery -Verbose:$false | Sort-Object -Property 'id' | Select-Object -Last 1); Break }
                    '^imports*'       { Return (Get-BsImport       -Verbose:$false | Sort-Object -Property 'id' | Select-Object -Last 1); Break }
                    Default           { Write-Error -Message "Unknown UrlFunction In BookStackMultiPart: '$UrlFunction'" }
                }
            }
        }
        Catch {
            Return $_.Exception
        }
    }

    End {
        $client.Dispose()
        $formData.Dispose()
        $fileStream.Close()
        $fileStream.Dispose()
    }
}
