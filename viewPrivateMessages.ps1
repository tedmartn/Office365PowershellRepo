Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unresctricted
## Input your Office 365 Admin Credentials
$UserCredential = Get-Credential
## This creates the session and authenticates the session with your Office 365 Credentials 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
## This connects you to Office 365 Exchange utilizing the Session Above
Import-PSSession $Session -DisableNameChecking
## This command allows users to see all private messages within an Mailbox itself 
Add-MailboxPermission -Identity coreyh@buildtosuitinc.com -User administrator@buildtosuitinc.onmicrosoft.com -AccessRights FullAccess -AutoMapping:$false


https://outlook.office.com/owa/jgardner@nashbrothers.com/?offline=disabled
https://outlook.office.com/owa/user@domain.com/?offline=disabled