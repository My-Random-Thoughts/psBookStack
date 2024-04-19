Function Get-BsAttachment {
<#
    .SYNOPSIS
        Get a listing of attachments visible to the user, or view the details of a single attachment

    .DESCRIPTION
        Get a listing of attachments visible to the user, or view the details of a single attachment

    .PARAMETER Id
        The identifier of the attachment

    .PARAMETER Filter
        Specifies a filter to help narrow down results

    .PARAMETER Decode
        Optional switch to decode the content from a Base64 string.

    .EXAMPLE
        Get-BsAttachment

    .EXAMPLE
        Get-BsAttachment -Id 13 -Decode

    .EXAMPLE
        Get-BsAttachment -Filter '[id:lt]=10'

    .FUNCTIONALITY
        GET: attachments
        GET: attachments/{id}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'filter')]
        [string]$Filter,

        [Parameter(ParameterSetName = 'id')]
        [switch]$Decode
    )

    Function decode {
        Param (
            [Parameter(Mandatory = $true)]
            [string]$inputString
        )

        Return ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($inputString)))
    }


    If ($Id) {
        $attachment = (Invoke-BookStackQuery -UrlFunction "attachments/$Id" -RestMethod Get)
        If ($Decode.IsPresent) {
            Add-Member -InputObject $attachment -MemberType NoteProperty -Name "content_decoded" -Value (decode($attachment.content))
        }
        Write-Output $attachment
    }
    Else {
        If ($Filter) { $parsedFilter = "?filter$Filter" }
        Write-Output (Invoke-BookStackQuery -UrlFunction "attachments$parsedFilter" -RestMethod Get)
    }
}
