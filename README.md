# BookStack PowerShell Module
## Description
This module talks to the BookStack API to help in managing your installation.

The API can be located at `https://<DNS Name or IP>/api`


## Download And Import
Download all the files into your PowerShell module path (usually C:\Program Files\WindowsPowerShell\Modules) and import it

`Import-Module -Name 'psBookStack'`

## Basic Usage
To start using the module, you need to authenticate with your BookStack installation:

`Connect-BookStackAPI -Url '<DNS Name or IP>' -Credential <PSCredential>`

`Connect-BookStackAPI -Url '<DNS Name or IP>' -Token 'abcde:12345'`

Once connected, you can start using any of the other commands.
For example, to list all shelves in your environment, use `Get-BsShelf`

## Comment Based Help
Every command has its own comment based help, so there should be no issues with getting information for the commands.

Most of the help comes from the API itself.


### Bugs / Issues
If you find any bugs or issues please let me know and I'll try to fix them.
