Function Invoke-BookStackQuery {
<#
    .SYNOPSIS
        Invokes the RestAPI for BookStack

    .DESCRIPTION
        Helps to avoid code duplication in functions when calling the BookStack API

    .PARAMETER UrlFunction
        The Rest API URL to use, excluding the hostname and port

    .PARAMETER ApiQuery
        The API query parameters

    .PARAMETER RestMethod
        One of "Default, Delete, Get, Head, Merge, Options, Patch, Post, Put, Trace"

    .PARAMETER FileName
        Filename to use when exporting

    .EXAMPLE
        Invoke-BookStackQuery -UrlFunction 'books' -RestMethod Get

    .EXAMPLE
        Invoke-BookStackQuery -UrlFunction 'shelves' -ApiQuery $apiQuery -RestMethod Post

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UrlFunction,

        [object]$ApiQuery,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$RestMethod,

        [string]$FileName
    )

    Begin {
        If ((Test-Path -Path variable:global:BookStackSession) -eq $false) {
            Throw "A valid session token has not been created, please use 'Connect-BookStackAPI' to create one"
        }

        [string]$pageOffset = "offset"
        If ($UrlFunction -like '*search?query*') { $pageOffset = 'page' }

        [hashtable]$iRestM = @{
            Uri         = "/api/$UrlFunction"
            RestMethod  = $RestMethod
            ContentType = 'application/json'
        }
    }

    Process {
        If ($ApiQuery -is [hashtable]) {
            $ApiQueryJson = (ConvertTo-Json -InputObject $ApiQuery -Depth 100)
        }
        ElseIf ($ApiQuery -is [array]    ) { $ApiQueryJson = (ConvertTo-Json -InputObject $ApiQuery -Depth 100) }
        ElseIf ($ApiQuery -is [string]   ) { $ApiQueryJson = $ApiQuery }
        Else   {}    # Do nothing

        # Add page number to URL for returning multiple items
        [int]$currentPage = ([regex]::Match($iRestM.Uri, "(?:[?&]$($pageOffset)=)([1-9]|[1-9][0-9]|[1-9][0-9][0-9])(?:&)?").Groups[1].Value)
        If ($currentPage -eq 0) {
            If ($iRestM.Uri -like '*search?query*') {
                $currentPage = 1
                $iRestM.Uri += '&page=1'
            }
            ElseIf ($iRestM.Uri -like '*?*') {
                $currentPage = 0
                $iRestM.Uri += '&offset=0'
            }
            Else {
                $currentPage = 0
                $iRestM.Uri += '?offset=0'
            }
        }

        If (-not [string]::IsNullOrEmpty($ApiQueryJson)) {
            $iRestM += @{
                Body =  $ApiQueryJson
            }
        }

        Try {
            Write-Verbose "Executing API method `"$($RestMethod.ToString().ToUpper())`" against `"$($iRestM.Uri)`""
            If ($ApiQuery) { Write-Debug "ApiQuery:`n$($ApiQuery | ConvertTo-Json -Depth 100)" }

            If ($FileName) {
                Invoke-BookStackRestMethod @iRestM -FileName $FileName
                Return "Exported as '$FileName'."
            }
            Else {
                $Output = (Invoke-BookStackRestMethod @iRestM -TimeOut 300)
            }

            If ([string]::IsNullOrEmpty($Output) -eq $true) {
                Return 'No results to return' #$null
            }

            Write-Verbose -Message "Total Items Found: $($Output.total), showing $($Output.data.Count)"
            If ($Output.data) {
                Write-Output ($Output.data)
            }
            Else {
                Write-Output $Output
            }

            # Output for any additional pages
            [int]$pageCount = $currentPage
            [int]$outputCount = ($Output.data.Count)

            If ($Output.total -gt $Output.data.Count) {
                Do {
                    $pageCount++
                    Write-Verbose -Message  "Retrieving page $pageCount ..."

                    If ($pageOffset -eq 'offset') {
                        $prevPageOffset = (($pageCount - 1) * 100)
                        $nextPageOffset = ( $pageCount      * 100)
                    }
                    Else {
                        $prevPageOffset = ($pageCount - 1)
                        $nextPageOffset = ($pageCount)
                    }

                    $iRestM.Uri = $iRestM.Uri.Replace("$($pageOffset)=$($prevPageOffset)", "$($pageOffset)=$($nextPageOffset)")
                    Write-Debug -Message "Executing API method `"$($RestMethod.ToString().ToUpper())`" against `"$($iRestM.Uri)`""
                    $Output = (Invoke-BookStackRestMethod @iRestM -TimeOut 300 -Verbose:$false)
                    $outputCount = ($Output.data.Count)

                    Write-Output ($Output.data)

                }
                While ($OutputCount -ne 0)
            }
        }
        Catch {
            Write-Error $_.Exception
        }
    }

    End {
    }
}
