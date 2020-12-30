Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
## Input your Office 365 Admin Credentials
$UserCredential = Get-Credential
## This creates the session and authenticates the session with your Office 365 Credentials 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
## This connects you to Office 365 Exchange utilizing the Session Above
Import-PSSession $Session -DisableNameChecking

$sharedMailboxes = @("alerts@rkdixon.com","360help@rkdixon.com","360install@rkdixon.com","360asm@rkdixon.com","rkd360app@rkdixon.com","ap@rkdixon.com","asmalerts@rkdixon.com","billing@rkdixon.com","billingdept@rkdixon.com","ceojuice@rkdixon.com","contracts@rkdixon.com","customeraccounts@rkdixon.com","d3@rkdixon.com","digitaltaskforce@rkdixon.com","dispatch@rkdixon.com","dmarc@rkdixon.com","hostmaster@rkdixon.com","internalsupplies@rkdixon.com","r2@rkdixon.com","machineorders@rkdixon.com","marketing@rkdixon.com","mr@rkdixon.com","mop@rkdixon.com","mpstrigger@rkdixon.com","oogcontracts@rkdixon.com","pmeters@rkdixon.com","s6@rkdixon.com","p2@rkdixon.com","purityplussched@rkdixon.com","rhs@rkdixon.com","sahelpdesk@rkdixon.com
","salesdepartment@rkdixon.com","soar@rkdixon.com","supplycalls@rkdixon.com","supplies@rkdixon.com","supplyreturns@rkdixon.com","r3@rkdixon.com","surveys@rkdixon.com","techreceipts@rkdixon.com","vadmin@rkdixon.com","rrecruitment@rkdixon.com","resumes@rkdixon.com","virtualoffice@rkdixon.com","itinfo@rkdixon.com","allbranchadministrators@rkdixon.com","cancel@premier-iowa.com")

foreach($mailbox in $sharedMailboxes)
{
    $fullAccess = Get-MailboxPermission -identity $mailbox -ResultSize Unlimited | ?{($_.IsInherited -eq $false) -and ($_.User -ne "NT Authority\SELF") -and ($_.AccessRights -like "FullAccess") -and ($_.User -notlike "S-1-5*")} 
    $fullAccess | Export-Csv "C:\Temp\fullaccess.csv"
}



