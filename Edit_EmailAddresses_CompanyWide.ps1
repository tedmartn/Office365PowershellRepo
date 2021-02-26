Import-Module activedirectory
$domain = "@aisystemsgroup.com"
$users = Get-ADUser -Filter * 


foreach ($user in $users)
{
    if ($user.GivenName -and $user.Surname) {
        $fname =$user.givenname[0]
        $lname =$user.surname
        $mailAddress = $fname + '.' + $lname + $domain
        Set-ADUser -Identity $user.samaccountname -EmailAddress $mailAddress
        }
    else {
        Write-Warning "User '$($user.SamAccountName)' has incomplete Name info"
    }


}



https://evotec.xyz/azure-ad-connect-synchronizing-mail-field-with-userprincipalname-in-azure/