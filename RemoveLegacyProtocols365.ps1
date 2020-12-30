$query = "SELECT * FROM [cwwebapp_rkd].[dbo].[CSD_v-O365_Creds] WHERE Company_Name NOT IN ('Siouxland Community Health Center','Team Works by Holzhauer','Four Seasons Power Wash, LLC','Counseling Associates, Inc.','Central Illinois Agency of Aging','Bi-State Business Solutions','Genesis Systems Group') " 
$365Creds = Invoke-Sqlcmd -query $query -serverinstance "rkd-dav-cwmanag\connectwise"

foreach ($cred in $365Creds)
{
    $username = $cred.username
    $password = $cred.password | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    $Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
        -ConfigurationName Microsoft.Exchange -Credential $credential `
        -Authentication Basic -AllowRedirection 
    Import-PSSession $Session -AllowClobber
    Get-CASMailbox -Filter {ImapEnabled -eq "true" -or PopEnabled -eq "true"} | Select-Object @{n = "Identity"; e = {$_.primarysmtpaddress}} | Set-CASMailbox -ImapEnabled $false -PopEnabled $false
    Get-CASMailboxPlan -Filter {ImapEnabled -eq "true" -or PopEnabled -eq "true"} | set-CASMailboxPlan -PopEnabled $false -ImapEnabled $false

}



