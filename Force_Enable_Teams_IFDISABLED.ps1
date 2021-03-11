connect-msolservice
$MSOLUsers = Get-MsolUser -All #| Where-Object { $_.Licenses.ServiceStatus.ServicePlan.ServiceName -match "TEAMS"}

foreach ($MSOLUser in $MSOLUsers) {
       if ($MSOLUser.Licenses.ServiceStatus.ServicePlan.ServiceName -match "TEAMS") {
           #do nothing
       } else {
            $MSOLLicenseOptions = New-MsolLicenseOptions -AccountSkuId "reseller-account:O365_BUSINESS_PREMIUM" -DisabledPlans $null
            Set-MsolUserLicense -UserPrincipalName $MSOLUser.UserPrincipalName -LicenseOptions $MSOLLicenseOptions
        }


#pmcconohy@northwestmech.com



}