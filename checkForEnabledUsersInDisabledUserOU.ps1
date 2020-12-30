## Goal of this Script is to search for Enabled Users in the Disabled Users OU
## Once found it will proceed to move the Enabled Users into the Enabled Users OU 
Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level = "INFO",

    [Parameter(Mandatory=$True)]
    [string]
    $Message,

    [Parameter(Mandatory=$False)]
    [string]
    $logfile
    )

    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $Line = "$Stamp $Level $Message"
    If($logfile) {
        Add-Content $logfile -Value $Line
    }
    Else {
        Write-Output $Line
    }
}

Import-Module ActiveDirectory
$searchBase = "OU=Disabled Accounts,DC=RKD,DC=Global-Imaging,DC=com"
$enabledUsers = get-aduser -Filter * -SearchBase $searchBase | where{$_.Enabled -eq $true}
$enabledUsers.UserPrincipalName