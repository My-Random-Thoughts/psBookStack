Function Find-BsUnShelvedBooks {
<#
    .SYNOPSIS
        Small wrapper to find any un-shelved books that may exist

    .DESCRIPTION
        Small wrapper to find any un-shelved books that may exist

    .EXAMPLE
        Find-BsUnShelvedBooks

    .FUNCTIONALITY

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/psBookStack
#>

    [CmdletBinding()]
    Param()

    [int[]]$shelvedBooks = @()
    [int[]]$allBooks = (Get-BsBook).id

    ForEach($shelf In (Get-BsShelf).id) {
        $shelvedBooks += (((Get-BsShelf -Id $shelf).books).id)
    }

    $difference = (Compare-Object -ReferenceObject $allBooks -DifferenceObject $shelvedBooks -PassThru)

    ForEach ($id In $difference) {
        Get-BsBook -Id $id
    }
}
