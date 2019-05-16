Function Connect-EXOnline {
    $credentials = Get-Credential
    Write-Output "Getting the Exchange Online cmdlets"
    $Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
        -ConfigurationName Microsoft.Exchange -Credential $credentials `
        -Authentication Basic -AllowRedirection 
    Import-PSSession $Session -AllowClobber
}

Connect-EXOnline
## Below Disables POP3 and IMAP for all existing mailboxes
Get-CASMailbox -Filter {ImapEnabled -eq "true" -or PopEnabled -eq "true"} | Select-Object @{n = "Identity"; e = {$_.primarysmtpaddress}} | Set-CASMailbox -ImapEnabled $false -PopEnabled $false
## Below Disables POP3 and IMAP for the Office 365 Mailbox Plans going forward
Get-CASMailboxPlan -Filter {ImapEnabled -eq "true" -or PopEnabled -eq "true"} | set-CASMailboxPlan -PopEnabled $false -ImapEnabled $false

