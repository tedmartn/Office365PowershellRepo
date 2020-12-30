#Config Variables
$SiteURL = "https://cyrfinancial1.sharepoint.com"
$FolderName = "Judd Properties"
$ParentFolderSiteRelativeURL= "/Shared Documents/Judd Properties"
 
#Get Credentials to connect
$Cred = Get-Credential
 
Try {
    #Connect to PNP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
     
    #sharepoint online powershell delete folder
    Remove-PnPFolder -Name $FolderName -Folder $ParentFolderSiteRelativeURL -Force -Recycle -ErrorAction Stop
    Write-host -f Green "Folder '$FolderName' Deleted Successfully!"
 
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}


#Read more: https://www.sharepointdiary.com/2016/09/sharepoint-online-powershell-to-delete-folder.html#ixzz6ZXRstFYk