Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
## Input your Office 365 Admin Credentials
$UserCredential = Get-Credential
## This creates the session and authenticates the session with your Office 365 Credentials 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
## This connects you to Office 365 Exchange utilizing the Session Above
Import-PSSession $Session -DisableNameChecking


## The long command below allow you to export all the Mailboxes in the Organization into a CSV for searchability, you can also specify an SMTP address to sort instead as well.
Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,@{Name=”EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_ -LIKE “SMTP:*”}}} | Sort-Object | Export-Csv "C:\temp\email-aliases.csv"