# Connects you to Active Directory
Import-Module ActiveDirectory

## Input Username & Password along with User you wish to copy.
$newUser = Read-Host -prompt "Please input the username of the new user" 
$newPassword = Read-Host -prompt "Please input the password for the new user" -AsSecureString
$copyUser = Read-Host -prompt "Please input the user you wish to copy"
write-host "You have inputted the new username of $newUser and $newPassword the user you copied was $copyUser"

## Copys the user instance of the user you wish to copy.
$newUserInstance = get-aduser -identity $copyUser -Properties  
# Creates the new Active Directory User based on these parameters
New-ADUser -Name 'Ted Test User Powershell' -Instance $newUserInstance -SamAccountName $newUser -AccountPassword $newPassword -UserPrincipalName $newUser@rkdixon.com 
