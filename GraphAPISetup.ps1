# First Step is to create a Certificate for authenticating into the API via 
#
#
# Your tenant name 
$TenantName        = "rkdtz.onmicrosoft.com"

# Where to export the certificate without the private key
$CerOutputPath     = "C:\Temp\PowerShellGraphCert.cer"

# What cert store you want it to be in
$StoreLocation     = "Cert:\CurrentUser\My"

# Expiration date of the new certificate
$ExpirationDate    = (Get-Date).AddYears(2)


# Splat for readability
$CreateCertificateSplat = @{
    FriendlyName      = "AzureApp"
    DnsName           = $TenantName
    CertStoreLocation = $StoreLocation
    NotAfter          = $ExpirationDate
    KeyExportPolicy   = "Exportable"
    KeySpec           = "Signature"
    Provider          = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    HashAlgorithm     = "SHA256"
}

# Create certificate
$Certificate = New-SelfSignedCertificate @CreateCertificateSplat

# Get certificate path
$CertificatePath = Join-Path -Path $StoreLocation -ChildPath $Certificate.Thumbprint

# Export certificate without private key
Export-Certificate -Cert $CertificatePath -FilePath $CerOutputPath | Out-Null



# Define AppId, secret and scope, your tenant name and endpoint URL
$AppId = '2a9a7068-6662-450e-902e-d171adfbe43f'
$AppSecret = 'H2Cbj-3.uvD5@lUXfo4hLr[.xwU]Ibnd'
$Scope = "https://graph.microsoft.com/.default"
$TenantName = "rkdtz.onmicrosoft.com"

$Url = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

# Add System.Web for urlencode
Add-Type -AssemblyName System.Web

# Create a list that we will join with "&" later on so that the code gets a bit cleaner
$BodyList = @(
        "client_id=$([System.Web.HttpUtility]::UrlEncode($AppId))",
        "client_secret=$([System.Web.HttpUtility]::UrlEncode($AppSecret))",
        "scope=$([System.Web.HttpUtility]::UrlEncode($Scope))",
        "grant_type=client_credentials"
)

# Splat the parameters for Invoke-Restmethod for cleaner code
$PostSplat = @{
    ContentType = 'application/x-www-form-urlencoded'
    Method = 'POST'
    # Create string by joining bodylist with '&'
    Body = ($BodyList -join '&')
    Uri = $Url
}

# Request the token!
$Request = Invoke-RestMethod @PostSplat