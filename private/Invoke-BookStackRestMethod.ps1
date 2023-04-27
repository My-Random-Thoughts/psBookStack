Function Invoke-BookStackRestMethod {
<#
    .SYNOPSIS
        Wrapper for built-in Invoke-RestMethod

    .DESCRIPTION
        Wrapper for built-in Invoke-RestMethod to cut down on code duplication

    .PARAMETER Uri
        Specifies the Uniform Resource Identifier (URI) of the internet resource to which the web request is sent

    .PARAMETER RestMethod
        Specifies the method used for the web request

    .PARAMETER Body
        Specifies the body of the web request

    .PARAMETER ContentType
        Specifies the ContentType of the data being sent.  Defaults to 'application/json'

    .PARAMETER TimeOut
        Specifies how long the request can be pending before it times out. Enter a value in seconds

    .EXAMPLE
        Invoke-BookStackRestMethod -Uri $Uri -Method 'Post' -ContentType $Content -TimeOut 600 -Body $body

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/BookStack
#>

    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope = 'Function')]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$RestMethod,

        [object]$Body,

        [string]$ContentType = 'application/json',

        [int]$TimeOut = 15
    )

    Begin {
        [string]$url  = $global:BookStackSession.Headers['Url']
        [string]$auth = $global:BookStackSession.Headers['Authorization']

        [hashtable]$invokeRestMethod = @{
            Uri             =   "$url$Uri"
            Method          =    $RestMethod
            TimeOut         =    $TimeOut
            UseBasicParsing =    $true
            ErrorAction     =   'Stop'
            ContentType     =    $ContentType
            Headers         = @{'Authorization' = $auth}
        }
    }

    Process {
        If (-not [string]::IsNullOrEmpty($Body)) { $invokeRestMethod += @{ Body = $Body }}
        Return (Invoke-RestMethod @invokeRestMethod)
    }

    End {
    }
}
