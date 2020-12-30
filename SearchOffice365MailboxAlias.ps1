Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
## Input your Office 365 Admin Credentials
$UserCredential = Get-Credential
## This creates the session and authenticates the session with your Office 365 Credentials 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
## This connects you to Office 365 Exchange utilizing the Session Above
Import-PSSession $Session -DisableNameChecking


Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:tmartin@rkdixon.com'} 