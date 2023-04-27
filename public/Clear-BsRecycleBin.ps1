Function Clear-BsRecycleBin {
<#
    .SYNOPSIS
        Small wrapper to completely empty the recycle bin

    .DESCRIPTION
        Small wrapper to completely empty the recycle bin

    .EXAMPLE
        Clear-BsRecycleBin

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param ()

    [void](Get-BsRecycleBin | Remove-BsRecycleBinItem)
}
