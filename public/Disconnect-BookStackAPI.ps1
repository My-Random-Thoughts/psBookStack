Function Disconnect-BookStackAPI {
<#
    .SYNOPSIS
        Removes the authentication session to BookStack

    .DESCRIPTION
        Removes the authentication session to BookStack

    .EXAMPLE
        Disconnect-BookStackAPI

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
    )

    If (Get-Variable -Name 'BookStackSession' -ErrorAction SilentlyContinue) {
        If ($PSCmdlet.ShouldProcess("$($BookStackSession.Headers.Url)")) {
            $Global:BookStackSession = $null

            Remove-Variable -Name 'BookStackSession' -Force
            Write-Output "BookStack session token removed"
        }
    }
}
