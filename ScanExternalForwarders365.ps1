## $query = "SELECT * FROM [cwwebapp_rkd].[dbo].[CSD_v-O365_Creds] WHERE Company_Name NOT IN ('Siouxland Community Health Center','Team Works by Holzhauer','Four Seasons Power Wash, LLC','Counseling Associates, Inc.','Central Illinois Agency of Aging','Bi-State Business Solutions','Genesis Systems Group') " 
$query = "SELECT * FROM [cwwebapp_rkd].[dbo].[CSD_v-O365_Creds] WHERE Company_Name = ('Build To Suit Inc') " 
$365Creds = Invoke-Sqlcmd -query $query -serverinstance "rkd-dav-cwmanage.rkd.global-imaging.com\connectwise"


foreach ($cred in $365Creds)
{
    $username = $cred.username
    $password = $cred.password | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    $Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
        -ConfigurationName Microsoft.Exchange -Credential $credential `
        -Authentication Basic -AllowRedirection 
    Import-PSSession $Session -AllowClobber
    $domains = Get-AcceptedDomain
    $mailboxes = Get-Mailbox -ResultSize Unlimited
    foreach ($mailbox in $mailboxes) {
 
    $forwardingRules = $null
    Write-Host "Checking rules for $($mailbox.displayname) - $($mailbox.primarysmtpaddress)" -foregroundColor Green
    $rules = get-inboxrule -Mailbox $mailbox.primarysmtpaddress
     
    $forwardingRules = $rules | Where-Object {$_.forwardto -or $_.forwardasattachmentto}
        
    foreach ($rule in $forwardingRules) {
        $recipients = @()
        $recipients = $rule.ForwardTo | Where-Object {$_ -match "SMTP"}
        $recipients += $rule.ForwardAsAttachmentTo | Where-Object {$_ -match "SMTP"}
     
        $externalRecipients = @()
 
        foreach ($recipient in $recipients) {
            $email = ($recipient -split "SMTP:")[1].Trim("]")
            $domain = ($email -split "@")[1]
 
            if ($domains.DomainName -notcontains $domain) {
                $externalRecipients += $email
            }    
        }
 
        if ($externalRecipients) {
            $extRecString = $externalRecipients -join ", "
            Write-Host "$($rule.Name) forwards to $extRecString" -ForegroundColor Yellow
            }
        }
    }   
}

