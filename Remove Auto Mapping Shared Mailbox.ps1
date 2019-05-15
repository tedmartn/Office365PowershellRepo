Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unresctricted

## Input your Office 365 Admin Credentials
$UserCredential = Get-Credential

## This creates the session and authenticates the session with your Office 365 Credentials 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

## This connects you to Office 365 Exchange utilizing the Session Above
Import-PSSession $Session -DisableNameChecking

## Filters all Email based on specific domain
get-mailbox -Filter {EmailAddresses -like "*rkdixon.com*" -or EmailAddresses -like "*premier*"} | Get-MailboxPermission -Identity $userMailbox

## Grants Full Access to mailbox but turns off Auto Mapping so doesn't appear in Outlook for the User
Add-MailboxPermission -Identity requestotg@rkdixon.com -User dmiller@rkdixon.com -AccessRights FullAccess -AutoMapping:$false