Import-Module ActiveDirectory
$newdomain = "@ryanassociatesinc.com"
$SMTP = 'smtp:'
$Users = Get-ADUser -Filter * 
foreach($user in $users){
    #Verifies User has Firstname/LastName before setting this, will write a warning
    if ($user.GivenName -and $user.Surname) {
    $fname = $($user.givenname[0])
    $lname = $($user.surname)
    $proxyaddresses = $SMTP + $fname + '.' + $lname + $newdomain
    Set-ADUser -Identity $user.samaccountname -add @{proxyaddresses = $proxyaddresses} -WhatIf
    Write-Host "Adding $($proxyaddresses) to $($user.samaccountname) Account" -ForegroundColor Green
    }
    
    else {
    Write-Warning "User '$($user.SamAccountName)' has incomplete Name Info"
    }



}


