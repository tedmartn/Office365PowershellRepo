## Goal of this Script is to search for Disabled Users in the Enabled Users OU
## Once these users are populated into the $disabledUsers variable, it will proceed to move them into the Disabled Users OU
## After Moving, it will log user who were moved, the date in a local log file

Import-Module ActiveDirectory
$Logfile = "C:\PowershellLog\ADUserMove.txt"
$date = Get-Date
$domain = "rkd.global-imaging.com"
$EntireSearchBase = "OU=RKDUsers,DC=RKD,DC=Global-Imaging,DC=com"
$disabledUsersOU = "OU=Disabled Users,OU=Disabled Accounts,DC=RKD,DC=Global-Imaging,DC=com"
$disabledUsers = get-aduser -Filter * -SearchBase $EntireSearchBase | Where-Object{$_.Enabled -eq $false} | Where-Object{($_.distinguishedname -notlike '*Shared Mailboxes*')} | Where-Object{($_.distinguishedname -notlike '*Service Accounts*')} 

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

ForEach($user in $disabledUsers) {
    Move-ADObject -Identity $user.objectGUID -TargetPath "$disabledUsersOU"
    Write-Log -Level INFO -Message "Moved $user to the $disabledUsersOU" -logfile "C:\ADAdminLogs\test.txt"   
}




